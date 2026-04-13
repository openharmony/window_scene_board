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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EventConstants, GlobalContext, localEventManager } from '@ohos/frameworkwrapper';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { CommonConstants } from '../../TsIndex';
import { AppIconContextMenuIface } from '../interface/AppIconContextMenuIface';
import { AppIconConfig } from '../config/AppIconConfig';
import { AppIconMenuVm } from './AppIconMenuVm';
import { AppIconBadgeVm } from './AppIconBadgeVm';
import { BadgeAnimationType } from '../../uicomponents/CustomBadge';

const TAG: string = 'AppIconContextMenu';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

export interface AppIconContextMenuParam {
  appIconConfig: AppIconConfig;
  iconMenuVm: AppIconMenuVm;
  iconBadgeVm: AppIconBadgeVm;
  contentBuilder: CustomBuilder;
  longPressImageBuilder: CustomBuilder;
  isLongPressMenu?: boolean;
}

export class AppIconContextMenu implements AppIconContextMenuIface {
  private appIconConfig?: AppIconConfig;
  private iconMenuVm?: AppIconMenuVm;
  private iconBadgeVm?: AppIconBadgeVm;
  private longPressImageBuilder?: CustomBuilder;
  private contentBuilder?: CustomBuilder;
  private desktopContext: ServiceExtensionContext = GlobalContext.getContext();
  private isLongPressMenu: boolean = true;

  public initContextMenuParam(param: AppIconContextMenuParam): AppIconContextMenuIface {
    if (!param || !param.appIconConfig || !param.iconMenuVm || !param.longPressImageBuilder ||
      !param.contentBuilder) {
      log.showError('initContextMenuParam failed, param is invalid!');
      return this;
    }

    this.appIconConfig = param.appIconConfig;
    this.iconMenuVm = param.iconMenuVm;
    this.iconBadgeVm = param.iconBadgeVm;
    this.longPressImageBuilder = param.longPressImageBuilder;
    this.contentBuilder = param.contentBuilder;
    this.isLongPressMenu = param.isLongPressMenu as boolean;
    return this;
  }

  public showContextMenu(): boolean {
    if (!this.appIconConfig) {
      return false;
    }
    return this.appIconConfig.enableMenu;
  }

  /**
   * 获取菜单内容builder
   * @returns CustomBuilder
   */
  public getContentBuilder(): CustomBuilder {
    return this.contentBuilder;
  }

  /**
   * 1.获取鼠标右键菜单的配置信息
   * 2.需要区分PC与手机平板的鼠标右键规格
   *
   * @param placement 菜单位置
   * @returns ContextMenuOptions
   */
  public getRightClickMenuOptions(placement: Placement): ContextMenuOptions {
    return {
      offset: this.iconMenuVm?.menuOffset,
      placement: this.appIconConfig?.enableRightClickMenuFollowIcon ? placement :
        this.iconMenuVm?.getMenuPlacement(this.isLongPressMenu),
      backgroundBlurStyle: this.iconMenuVm?.backgroundBlurStyle,
      onDisappear: () => {
        this.onMenuDisappear();
      },
      aboutToDisappear: this.appIconConfig?.enableRightClickMenuFollowIcon ? () => {
      } : () => {
        this.iconMenuVm?.setIsMenuShow(false);
      },
      aboutToAppear: this.appIconConfig?.enableRightClickMenuFollowIcon ? () => {
      } : () => {
        this.iconMenuVm?.setIsMenuShow(true);
      },
      transition: this.iconMenuVm?.getMenuTransition(this.isLongPressMenu),
      layoutRegionMargin: this.iconMenuVm?.layoutRegionMargin
    };
  }

  /**
   * 获取手势长按菜单的配置信息
   *
   * @returns ContextMenuOptions
   */
  public getLongPressMenuOptions(): ContextMenuOptions {
    return {
      offset: this.iconMenuVm?.menuOffset,
      placement: this.iconMenuVm?.getMenuPlacement(this.isLongPressMenu),
      preview: this.appIconConfig?.enableLongPressMenuPreview ? this.longPressImageBuilder : MenuPreviewMode.NONE,
      backgroundBlurStyle: this.iconMenuVm?.backgroundBlurStyle,
      onDisappear: () => {
        this.onMenuDisappear();
      },
      aboutToDisappear: () => {
        this.iconMenuVm?.setIsMenuShow(false);
      },
      aboutToAppear: () => {
        this.iconMenuVm?.setIsMenuShow(true);
      },
      onWillAppear: () => {
        localEventManager.sendLocalEventSticky(
          EventConstants.EVENT_DESKTOP_MENU_EVENT, CommonConstants.SCALE_FACTOR_WHEN_MENU_SHOW);
      },
      onWillDisappear: () => {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_DESKTOP_MENU_EVENT, 1);
      },
      previewAnimationOptions: this.iconMenuVm?.getMenuPreviewAnimOptions(),
      transition: this.iconMenuVm?.getMenuTransition(this.isLongPressMenu),
      layoutRegionMargin: this.iconMenuVm?.layoutRegionMargin,
      previewBorderRadius: 0
    };
  }

  /**
   * 菜单隐藏回调
   */
  public onMenuDisappear(): void {
    this.desktopContext?.eventHub.emit(CommonConstants.EVENTHUB_MENU_DISAPPEAR);
    if (this.iconBadgeVm) {
      this.iconBadgeVm.animate = BadgeAnimationType.TOUCH_UP;
    }
  }

  /**
   * 菜单显示回调
   */
  public onMenuAppear(): void {
    this.iconMenuVm?.setIsMenuShow(true);
  }
}