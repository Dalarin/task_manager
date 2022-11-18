import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/repository/tag_repository.dart';

import '../../models/tag.dart';

part 'tag_event.dart';

part 'tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  final TagRepository tagRepository;

  TagBloc(this.tagRepository) : super(TagInitial()) {
    on<GetTagsListOfTask>((event, emit) => _getTagsOfTask(event, emit));
    on<GetTagsListOfUser>((event, emit) => _getTagsOfUser(event, emit));
    on<UpdateTag>((event, emit) => _updateTag(event, emit));
    on<DeleteTag>((event, emit) => _deleteTag(event, emit));
    on<CreateTag>((event, emit) => _createTag(event, emit));
  }

  void _catchHandler(event, emit, Exception exception) {
    if (exception is SocketException) {
      emit(const TagError(
        'Ошибка. Проверьте интернет соединение и попробуйте снова',
      ));
    } else {
      emit(const TagError('Ошибка загрузки информации'));
    }
  }

  _createTag(CreateTag event, emit) async {
    try {
      if (event.title.isEmpty) {
        emit(const TagError('Заполните все поля и попробуйте снова'));
      } else {
        emit(TagLoading());
        Tag tag = Tag(
          userId: event.userId,
          title: event.title,
          color: event.color.toString(),
        );
        Tag? createdTag = await tagRepository.createTag(tag);
        if (createdTag != null) {
          event.tags.add(createdTag);
          emit(TagListLoaded(event.tags));
        } else {
          emit(const TagError('Ошибка создания категории'));
        }
      }
    } on Exception catch (exception) {
      _catchHandler(event, emit, exception);
    }
  }

  _deleteTag(event, emit) async {
    try {
      emit(TagLoading());
      bool deleted = await tagRepository.deleteTag(event.tagId);
      if (!deleted) {
        emit(const TagError(
          'Ошибка. Проверьте интернет соединение и попробуйте снова',
        ));
      } else {
        event.tags.removeWhere((element) => element.id == event.tagId);
        emit(TagListLoaded(event.tags));
      }
    } on Exception catch (exception) {
      _catchHandler(event, emit, exception);
    }
  }

  _updateTag(UpdateTag event, emit) async {
    try {
      emit(TagLoading());
      Tag? updated = await tagRepository.updateTag(event.tagId, event.tag);
      if (updated == null) {
        emit(const TagError(
          'Ошибка. Проверьте интернет соединение и попробуйте снова',
        ));
      } else {
        event.tags.removeWhere((element) => element.id == event.tagId);
        event.tags.add(updated);
        event.tags.sort((a,b) => a.id!.compareTo(b.id!));
        emit(TagListLoaded(event.tags));
      }
    } on Exception catch (exception) {
      _catchHandler(event, emit, exception);
    }
  }

  _getTagsOfTask(event, emit) async {
    try {
      emit(TagLoading());
      final tagList = await tagRepository.fetchTagsByTaskId(event.taskId);
      emit(tagList == null
          ? const TagError('Ошибка загрузки')
          : TagListLoaded(tagList));
    } on Exception catch (exception) {
      _catchHandler(event, emit, exception);
    }
  }

  _getTagsOfUser(event, emit) async {
    try {
      emit(TagLoading());
      final tagList = await tagRepository.fetchTagsByUserId(event.userId);
      emit(tagList == null
          ? const TagError('Ошибка загрузки')
          : TagListLoaded(tagList));
    } on Exception catch (exception) {
      _catchHandler(event, emit, exception);
    }
  }
}
