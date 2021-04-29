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
	              dependencies: []),
	          .testTarget(
	              name: "MimicTests",
	              dependencies: ["Mimic"]),
	      ]
)

