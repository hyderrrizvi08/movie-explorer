import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_api/models/popular_model.dart';
import 'package:movie_api/screens/detailscreen.dart';
import 'package:movie_api/config/api_config.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Future<PopularModel> getPopular() async {
    final response = await http.get(
      Uri.parse(
        "https://api.themoviedb.org/3/movie/popular?api_key=${ApiConfig.apiKey}",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PopularModel.fromJson(data);
    } else {
      throw Exception(
        "API request failed. Status Code: ${response.statusCode}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        title: Text(
          "Movie Explorer",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Center(
        child: FutureBuilder(
          future: getPopular(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData) {
              return Text("Loading");
            } else {
              //start

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data!.results!.length,
                itemBuilder: (context, index) {
                  final movie = snapshot.data!.results![index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Poster
                          Image.network(
                            "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                            height: 190,
                            width: 125,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 190,
                                width: 125,
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.movie,
                                  size: 45,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),

                          // Movie information
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: SizedBox(
                                height: 158,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title
                                    Text(
                                      movie.title ?? "Unknown Movie",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    // Release date
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          size: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 7),
                                        Text(
                                          movie.releaseDate ?? "Unknown",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const Spacer(),

                                    // Rating
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.star_rounded,
                                            color: Colors.amber,
                                            size: 19,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            movie.voteAverage?.toStringAsFixed(
                                                  1,
                                                ) ??
                                                "N/A",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF9A7200),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const Spacer(),

                                    // Details
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Detailscreen(id: movie.id!),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "View Details",
                                            style: TextStyle(
                                              color: Colors.blue.shade700,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 12,
                                            color: Colors.blue.shade700,
                                          ),
                                        ],
                                      ),
                                    ),
                                    //
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );

              //end
            }
          },
        ),
      ),
    );
  }
}
