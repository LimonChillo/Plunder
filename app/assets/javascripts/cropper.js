function update_crop(coords) {
  $('#crop_x').val(coords.x);
  $('#crop_y').val(coords.y);
  $('#crop_w').val(coords.w);
  $('#crop_h').val(coords.h);
  console.log(coords.x);
}

