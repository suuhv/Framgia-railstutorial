<script type="text/javascript">
  $('#micropost_picture').bind('change', function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > Settings.micropost.picture_size) {
      alert(<%= t ".smaller" %>);
    }
  });
</script>
