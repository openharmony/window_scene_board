/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { LogDomain, Logger } from '@ohos/basicutils';

const TAG = 'MenuPreHandlerModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
/**
 * 菜单预处理数据模型
 */
export class MenuPreHandlerModel {
  //是否显示桌面右键的'粘贴为快捷方式'菜单项
  public isShowPasteShortcutMenu: boolean = false;

  public setIsShowPasteShortcutMenu(isShowPasteShortcut: boolean ): void {
    log.showInfo(TAG, `setIsShowPasteShortcutMenu,isShowPasteShortcut ${isShowPasteShortcut}`);
    this.isShowPasteShortcutMenu = isShowPasteShortcut;
  }

  public init(): void {
    log.showInfo(TAG, 'init');
    this.isShowPasteShortcutMenu = false;
  }

  public toString(): string {
    return `MenuPreHandlerModel: isShowPasteShortcutMenu: ${this.isShowPasteShortcutMenu}`;
  }
}
