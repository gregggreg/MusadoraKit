//
//  LibraryAlbum.swift
//  MusadoraKit
//
//  Created by Rudrank Riyam on 14/08/21.
//

import MediaPlayer

public extension MLibrary {

  /// Fetch an album from the user's library by using its identifier.
  ///
  /// - Parameters:
  ///   - id: The unique identifier for the album.
  /// - Returns: `Album` matching the given identifier.
  @available(macOS, unavailable)
  @available(macCatalyst, unavailable)
  static func album(id: MusicItemID) async throws -> Album {
    if #available(iOS 16.0, tvOS 16.0, watchOS 9.0, macOS 14, macCatalyst 17.0, *) {
      var request = MusicLibraryRequest<Album>()
      request.filter(matching: \.id, equalTo: id)
      let response = try await request.response()

      guard let album = response.items.first else {
        throw MusadoraKitError.notFound(for: id.rawValue)
      }
      return album
    } else {
      let request = MLibraryResourceRequest<Album>(matching: \.id, equalTo: id)
      let response = try await request.response()

      guard let album = response.items.first else {
        throw MusadoraKitError.notFound(for: id.rawValue)
      }
      return album
    }
  }

  /// Fetch all albums from the user's library in alphabetical order.
  ///
  /// - Parameters:
  ///   - limit: The number of albums returned.
  /// - Returns: `Albums` for the given limit.
  @available(macOS, unavailable)
  @available(macCatalyst, unavailable)
  static func albums(limit: Int = 50) async throws -> Albums {
    if #available(iOS 16.0, macOS 14.0, macCatalyst 17.0, tvOS 16.0, watchOS 9.0, *) {
      var request = MusicLibraryRequest<Album>()
      request.limit = limit
      let response = try await request.response()
      return response.items
    } else {
      var request = MLibraryResourceRequest<Album>()
      request.limit = limit
      let response = try await request.response()
      return response.items
    }
  }

  /// Fetch multiple albums from the user's library by using their identifiers.
  ///
  /// - Parameters:
  ///   - ids: The unique identifiers for the albums.
  /// - Returns: `Albums` matching the given identifiers.
  static func albums(ids: [MusicItemID]) async throws -> Albums {
    if #available(iOS 16.0, macOS 14.0, macCatalyst 17.0, tvOS 16.0, watchOS 9.0, *) {
      var request = MusicLibraryRequest<Album>()
      request.filter(matching: \.id, memberOf: ids)
      let response = try await request.response()
      return response.items
    } else {
      let request = MLibraryResourceRequest<Album>(matching: \.id, memberOf: ids)
      let response = try await request.response()
      return response.items
    }
  }

  /// Access the total number of albums in the user's library.
  @available(iOS 16.0, tvOS 16.0, watchOS 9.0, macOS 14.0, macCatalyst 17.0, *)
  static var albumsCount: Int {
    get async throws {
      let request = MusicLibraryRequest<Album>()
      let response = try await request.response()
      return response.items.count
    }
  }

  /// Access the total number of albums in the user's library.
  @available(macOS, unavailable)
  @available(macCatalyst, unavailable)
  @available(tvOS, unavailable)
  @available(watchOS, unavailable)
  static var albumsItemsCount: Int {
    get async throws {
      if let items = MPMediaQuery.albums().items {
        return items.count
      } else {
        throw MediaPlayError.notFound(for: "albums")
      }
    }
  }

  /// Taken from https://github.com/marcelmendesfilho/MusadoraKit/blob/feature/improvements/Sources/MusadoraKit/Library/LibraryAlbum.swift
  /// Thanks @marcelmendesfilho!
  /// Add an album to the user's library by using its identifier.
  ///
  /// - Parameters:
  ///   - id: The unique identifier for the album.
  /// - Returns: `Bool` indicating if the insert was successfull or not.
  static func addAlbum(id: MusicItemID) async throws -> Bool {
    let request = MAddResourcesRequest([(item: .albums, value: [id])])
    let response = try await request.response()
    return response
  }

  /// Add multiple albums to the user's library by using their identifiers.
  ///
  /// - Parameters:
  ///   - ids: The unique identifiers for the albums.
  /// - Returns: `Bool` indicating if the insert was successfull or not.
  static func addAlbums(ids: [MusicItemID]) async throws -> Bool {
    let request = MAddResourcesRequest([(item: .albums, value: ids)])
    let response = try await request.response()
    return response
  }
}

@available(iOS 16.0, tvOS 16.0, watchOS 9.0, macOS 14.0, macCatalyst 17.0, *)
public extension MHistory {
  /// Fetch recently added albums from the user's library sorted by the date added.
  ///
  /// - Parameters:
  ///   - limit: The number of albums returned.
  /// - Returns: `Albums` for the given limit.
  static func recentlyAddedAlbums(limit: Int = 25, offset: Int) async throws -> Albums {
    var request = MusicLibraryRequest<Album>()
    request.limit = limit
    request.offset = offset
    request.sort(by: \.libraryAddedDate, ascending: false)
    let response = try await request.response()
    return response.items
  }

  /// Fetch recently played albums from the user's library sorted by the date added.
  ///
  /// - Parameters:
  ///   - limit: The number of albums returned.
  /// - Returns: `Albums` for the given limit.
  static func recentlyPlayedAlbums(limit: Int = 25, offset: Int) async throws -> Albums {
    var request = MusicLibraryRequest<Album>()
    request.limit = limit
    request.offset = offset
    request.sort(by: \.lastPlayedDate, ascending: false)
    let response = try await request.response()
    return response.items
  }
}
