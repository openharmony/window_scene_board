/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { RectInfo } from './RectInfo';

export enum StartType {
  APP = 0,
  CARD,
  FOLDER,
  DESKTOP_APP,
  DOCK_APP,
  APP_CENTER_APP,
  RECENT_DOCK_APP,
  SHORTCUT_APP,
  SHORTCUT_MENU,
  SCREEN_LOCK_TOOLS,
  SMALL_FOLDER_APP,
  FILE_FOLDER,
  STATUS_BAR_TRAY,
}
//添加依赖文件
/**
 * CompanionIconInfo interface //记录
 */
export interface CompanionIconInfo {
  iconId: string;
  bundleName: string;
  abilityName: string;
  moduleName: string;
  iconNumber: number;
  iconRadius: number;
  startAppType: StartType;
  isSameLocation?: boolean;
  cardId: string;
  cardDimension?: FormDimension;
  extraId?: string;
  appIndex?: number;
  shortcutId?: string;
  smallFolderId?: string;
  needBadge?: boolean;
  iconRect?: RectInfo;
  appInstanceKey?: string;
}
