import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:qinject/qinject.dart';

import '../../../tiles/model.dart';

class TileListItem extends StatefulWidget {
  static final _audioPlayer = Qinject.use<TileListItem, AudioPlayer>();
  final Tile tile;
  final Category category;
  final double width;
  final double height;

  const TileListItem(this.tile, this.category, this.width, this.height,
      {Key? key})
      : super(key: key);

  @override
  State<TileListItem> createState() => _TileListItemState();
}

class _TileListItemState extends State<TileListItem> {
  final RoundedRectangleBorder _shape;
  late final RoundedRectangleBorder _selectedShape;

  _TileListItemState()
      : _shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(
              width: 1.0,
              color: Colors.black12,
            )),
        _selectedShape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(
              width: 2.5,
              color: Colors.black12,
            ));

  var selected = false;

  onTap(TapDownDetails tdd) async {
    setState(() => selected = true);

    final playComplete = TileListItem._audioPlayer.onPlayerComplete.first;

    await TileListItem._audioPlayer
        .play(DeviceFileSource(widget.tile.audio.path));

    await playComplete;

    setState(() => selected = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: onTap,
        child: SizedBox(
            height: widget.height,
            width: widget.width,
            child: Card(
                shape: selected ? _selectedShape : _shape,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(
                        leading: Icon(widget.category.icon),
                        title: Text(widget.tile.title),
                      ),
                      Expanded(
                        child: Image.file(widget.tile.image),
                      ),
                      const SizedBox(height: 10)
                    ]))));
  }
}
