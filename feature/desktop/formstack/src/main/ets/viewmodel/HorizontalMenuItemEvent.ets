/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResourceManager, localEventManager } from '@ohos/frameworkwrapper';
import { MenuInfo, StyleConstants, EventConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { HorizontalMenuViewData } from '../viewmodel/HorizontalMenuViewData';

const TAG: string = 'HorizontalMenuItemEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class HorizontalMenuItemEvent {
  public mViewData: HorizontalMenuViewData = new HorizontalMenuViewData();
  public mMenuInfo: MenuInfo = new MenuInfo();
  public mCloseMenuCb: () => void = () => {
    log.showError('closeMenuCb is invalid!')
  };

  public initData(viewData: HorizontalMenuViewData, menuInfo: MenuInfo, closeMenuCb: () => void): void {
    this.mViewData = viewData;
    this.mMenuInfo = menuInfo;
    this.mCloseMenuCb = closeMenuCb;
  }

  public updateIcon(): void {
    if (this.mMenuInfo.shortcutIconId !== -1) {
      ResourceManager.getInstance().getAppIconWithCache(this.mMenuInfo.shortcutIconId,
        String(this.mMenuInfo.bundleName), String(this.mMenuInfo.moduleName), (src: string) => {
          this.mViewData.mShortcutIcon = src;
        }, StyleConstants.DEFAULT_ICON);
    } else if (!CheckEmptyUtils.isEmpty(this.mMenuInfo.menuImgSrc)) {
      this.mViewData.mShortcutIcon = this.mMenuInfo.menuImgSrc as string;
    } else {
      log.showWarn('get shortcutIcon failed, use default shortcutIcon!');
    }
  }

  public updateShortcutName(): void {
    const shortcutName: string = this.mViewData.mShortcutName;
    if (this.mMenuInfo.shortcutLabelId !== -1) {
      ResourceManager.getInstance().getAppNameWithCache(this.mMenuInfo.shortcutLabelId, this.mMenuInfo.bundleName,
        this.mMenuInfo.moduleName, shortcutName, (name: string): void => {
          this.mViewData.mShortcutName = name;
        });
    } else if (!CheckEmptyUtils.isEmpty(this.mMenuInfo.menuText)) {
      this.mViewData.mShortcutName = this.mMenuInfo.menuText as string;
    } else {
      log.showWarn('get shortcutName failed, use default shortcutName.');
    }
  }

  public onClick(): void {
    this.mMenuInfo.onMenuClick?.();
    this.mCloseMenuCb();
    ContextMenu.close();
    localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);

    this.mViewData.mHoverState = false;
    this.mViewData.mPressState = false;
  }

  public onHover(isHover: boolean): void {
    this.mViewData.mHoverState = isHover;
  }

  public onTouch(event: TouchEvent): void {
    if (!event) {
      return;
    }

    if (event.type === TouchType.Down) {
      this.mViewData.mPressState = true;
    } else if (event.type === TouchType.Up) {
      this.mViewData.mPressState = false;
    } else {
      // 不处理状态变量
    }
  }

  public onMouse(event?: MouseEvent): void {
    if (!event || event.button !== MouseButton.Left) {
      return;
    }

    if (event.action === MouseAction.Press) {
      this.mViewData.mHoverState = false;
      this.mViewData.mPressState = true;
    } else if (event.action === MouseAction.Release) {
      this.mViewData.mPressState = false;
    } else {
      // 不处理状态变量
    }
  }
}