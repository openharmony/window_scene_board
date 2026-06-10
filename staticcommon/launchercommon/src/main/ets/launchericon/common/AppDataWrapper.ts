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

import { LogDomain, LogHelper, StartType } from '@ohos/basicutils';
import { AppData } from '@ohos/windowscene';
import { AppItemInfo, CommonConstants } from '../../TsIndex';

const TAG = 'AppDataWrapper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

export class AppDataWrapper extends AppData {
  public static getDefaultAppData(itemInfo: AppItemInfo, iconRadius: number): AppDataWrapper {
    if (!itemInfo) {
      log.showError('itemInfo is invalid!');
      return new AppDataWrapper().setIconRadius(iconRadius);
    }

    return new AppDataWrapper().setBundleName(itemInfo.bundleName)
      .setAbilityName(itemInfo.abilityName)
      .setAppIconNumber(itemInfo.appIconId)
      .setIconRadius(iconRadius)
      .setAppIndex(itemInfo.appIndex ?? 0)
      .setStartType(itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON ? StartType.SHORTCUT_APP : StartType.APP)
      .setShortcutId(itemInfo.shortcutId ?? '');
  }

  public setBundleName(bundleName: string): AppDataWrapper {
    this.bundleName = bundleName;
    return this;
  }

  public setAbilityName(abilityName: string): AppDataWrapper {
    this.abilityName = abilityName;
    return this;
  }

  public setAppIndex(appIndex: number): AppDataWrapper {
    this.appIndex = appIndex;
    return this;
  }

  public setShortcutId(shortcutId: string): AppDataWrapper {
    this.shortcutId = shortcutId;
    return this;
  }

  public setAppIconNumber(iconNumber: number): AppDataWrapper {
    this.appIconNumber = iconNumber;
    return this;
  }

  public setAppIconId(componentId: string): AppDataWrapper {
    this.appIconId = componentId;
    return this;
  }

  public setIconRadius(iconRadius: number): AppDataWrapper {
    this.iconRadius = iconRadius;
    return this;
  }

  public setCardId(cardId: string): AppDataWrapper {
    this.cardId = cardId;
    return this;
  }

  public setStartType(startAppType: StartType): AppDataWrapper {
    this.startAppType = startAppType;
    return this;
  }

  public setExtraId(extraId: string): AppDataWrapper {
    this.extraId = extraId;
    return this;
  }

  public setIsOpenFolder(isOpenFolder: boolean): AppDataWrapper {
    this.isOpenFolder = isOpenFolder;
    return this;
  }

  public setIsOuterDesktop(isOuterDesktop: string): AppDataWrapper {
    this.isOuterDesktop = isOuterDesktop;
    return this;
  }

  public setScreenId(screenId: number): AppDataWrapper {
    this.screenId = screenId;
    return this;
  }

  public setPersistentId(persistentId: string): AppDataWrapper {
    this.persistentId = persistentId;
    return this;
  }
}