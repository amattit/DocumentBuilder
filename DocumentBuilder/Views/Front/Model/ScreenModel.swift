//
//  ScreenModel.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 19.09.2023.
//

import Foundation
import SwiftUI

struct ScreenChapterModel: Identifiable, Hashable {
    let id: UUID
    var title: String
}

struct ScreenModel: Identifiable, Hashable {
    let id: UUID
    let parentId: UUID?
    var title: String
    var type: ScreenType; enum ScreenType: String {
        case screen
        case widget
    }
}

struct ScreenStateModel: Identifiable, Hashable {
    let id: UUID
    let parentId: UUID?
    var state: String
    var layoutLink: String
    var image: Data?
}

struct ScreenActionModel: Identifiable, Hashable {
    let id: UUID
    let parentId: UUID?
    var title: String
}

/*
 // Разделы
    id: UUID,
    title: Заметки,
 
 // Экраны
    id: UUID
    parentId: UUID? - ссылка на раздел
    title: String
    type: String - widget, screen, control?
    
 // Состояния экрана
    id: UUID
    parentId: UUID? - ссылка на экран
    state: String - состояние экрана. Данных нет, Данные есть, Данные есть частично, Переполнение - не помещается в отведенное пространство
    layoutLink: String? - ссылка на макет
    image: Data - сохраненная картинка
 
 // Модель экрана - ГОТОВО
    id: UUID
    parentId: UUID? - ссылка на экран
    title: String - название свойства
    objectType: String - тип свойства
    isRequired: Bool - обязательность
    comment: String - комментарий
 
 // Действия на экране
    id: UUID
    parentID: UUID? ссылка на экран
    title: Название действия (перейти на экран, вызвать сервис и тому подобное)
    trigger: String? - ?
    
 */
