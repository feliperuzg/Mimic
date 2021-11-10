// swift-tools-version:5.0

import PackageDescription
	
let package = Package(
	  name: "Mimic",
	      products: [
	          .library(
	              name: "Mimic",
	              targets: ["Mimic"]),
	      ],
	      dependencies: [],
	      targets: [
	          .target(
	              name: "Mimic",
	              dependencies: [],
	              path: "Sources")),
	          .testTarget(
	              name: "MimicTests",
	              dependencies: ["Mimic"]),
	      ]
)

