## **ImageFeed**

ImageFeed - многостраничное приложение предназначеное для просмотра изображений через API Unsplash.

- [Описание приложения](https://github.com/FilTon87/ImageFeed/new/main?filename=README.md#описание-приложения)
- [Технологии](https://github.com/FilTon87/ImageFeed/new/main?filename=README.md#технологии)
- [Скриншоты](https://github.com/FilTon87/ImageFeed/new/main?filename=README.md#скриншоты)

## **Описание приложения**
В приложении реализована авторизация через OAuth Unsplash.
Главный экран состоит из ленты с изображениями. Пользователь может просматривать ее, добавлять и удалять изображения из избранного.
Пользователи могут просматривать каждое изображение отдельно и делиться ссылкой на них за пределами приложения.
У пользователя есть профиль с избранными изображениями и краткой информацией о пользователе.
У приложения есть две версии: расширенная и базовая. В расширенной версии добавляется механика избранного и возможность лайкать фотографии при просмотре изображения на весь экран.


## **Технологии**
- архитектура MVP
- верстка в storyboard
- хранение данных Keychain
- многопоточность и блокировка UI
- основы Core Animation
- в приложении использованы: UImageView, UIButton, UILabel, WKWebView, UIProgressView, TabBarController, NavigationController, NavigationBar, UITableView, UITableViewCell
- интеграция зависимостей через SPM: Kingfisher, ProgressHUD, SwiftKeychainWrapper
- Unit-тесты
- UI-тесты

  
## **Скриншоты**
<img src="https://github.com/user-attachments/assets/d2c20023-32bc-4572-a338-73f814e9d89f" width="200" />
<img src="https://github.com/user-attachments/assets/3ad82e6e-4096-457e-889b-227e4437d7e5" width="200" />
<img src="https://github.com/user-attachments/assets/ff06ed53-a0f8-4b3c-a48c-cc73b889b801" width="200" />
<img src="https://github.com/user-attachments/assets/7b77e7d0-67ef-48f7-b82e-1e42b2f4e606" width="200" />

