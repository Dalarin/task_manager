import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/repository/tag_repository.dart';

import '../../models/tag.dart';

part 'tag_state.dart';

part 'tag_event.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  final TagRepository tagRepository;

  TagBloc(this.tagRepository) : super(TagInitial()) {
    on<TagEvent>((event, emit) {
      try {
        if (event is GetTagsListOfUser) {
          _getTagsOfUser(event, emit);
        } else if (event is GetTagsListOfTask) {
          _getTagsOfTask(event, emit);
        } else if (event is UpdateTag) {
          _updateTag(event, emit);
        } else if (event is DeleteTag) {
          _deleteTag(event, emit);
        } else if (event is CreateTag) {
          _createTag(event, emit);
        }
      } on SocketException {
        emit(const TagError(
          'Ошибка. Проверьте интернет соединение и попробуйте снова',
        ));
      } on Exception {
        emit(const TagError('Ошибка'));
      }
    });
  }

  Stream<void> _createTag(event, emit) async* {
    Tag? created = await tagRepository.createTag(event.tag);
    if (created == null) {
      emit(const TagError(
        'Ошибка. Проверьте интернет соединение и попробуйте снова',
      ));
    } else {
      event.tags.add(created);
      emit(TagListLoaded(event.tags));
    }
  }

  Stream<void> _deleteTag(event, emit) async* {
    bool deleted = await tagRepository.deleteTag(event.tagId);
    if (!deleted) {
      emit(const TagError(
        'Ошибка. Проверьте интернет соединение и попробуйте снова',
      ));
    } else {
      event.tags.removeWhere((element) => element.id == event.tagId);
      emit(TagListLoaded(event.tags));
    }
  }

  Stream<void> _updateTag(UpdateTag event, emit) async* {
    Tag? updated = await tagRepository.updateTag(event.tagId, event.tag);
    if (updated == null) {
      emit(const TagError(
        'Ошибка. Проверьте интернет соединение и попробуйте снова',
      ));
    } else {
      event.tags.removeWhere((element) => element.id == event.tagId);
      event.tags.add(updated);
      emit(TagListLoaded(event.tags));
    }
  }

  Stream<void> _getTagsOfTask(event, emit) async* {
    emit(TagLoading());
    final tagList = await tagRepository.fetchTagsByTaskId(event.taskId);
    emit(tagList == null? const TagError('Ошибка загрузки') : TagListLoaded(tagList));
  }

  Stream<void> _getTagsOfUser(event, emit) async* {
    emit(TagLoading());
    final tagList = await tagRepository.fetchTagsByUserId(event.userId);
    emit(tagList == null? const TagError('Ошибка загрузки') : TagListLoaded(tagList));
  }
}
