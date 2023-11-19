function executeHeic2any(blob, multiple, toType, quality, gifInterval) {
	return heic2any({
		blob,
		multiple: multiple,
		toType: toType,
		quality: quality,
		gifInterval: gifInterval
	});
}
