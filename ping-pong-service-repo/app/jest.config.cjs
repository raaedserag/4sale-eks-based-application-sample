module.exports = {
    reporters: [
        'default',
        ['jest-junit', {
            outputDirectory: "./test-results/jest",
            outputName: "ping-pong-service-results.xml"
        }]
    ]
}