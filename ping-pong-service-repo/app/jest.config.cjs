module.exports = {
    reporters: [
        'default',
        ['jest-junit', {
            outputDirectory: "./test-results/jest",
            outputName: "unit-testing-results.xml"
        }]
    ]
}