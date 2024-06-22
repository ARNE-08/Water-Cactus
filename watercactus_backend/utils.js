function convertWaterUnit(weight, unit) {
    const conversionFactor = 29.5735; // 1 oz = 29.5735 ml
  
    weight = parseFloat(weight);
  
    if (unit.toLowerCase() === 'ml') {
      const convertedWeight = weight / conversionFactor;
      return `${convertedWeight.toFixed(2)}`;
    } else if (unit.toLowerCase() === 'oz') {
      const convertedWeight = weight * conversionFactor;
      return `${convertedWeight.toFixed(2)}`;
    } else {
      return 'Invalid unit. Please specify either "ml" or "oz".';
    }
  }
  
  // Example usage
  // console.log(convertWaterUnit(500, 'ml')); // Output: "16.91 oz"

  module.exports = convertWaterUnit;