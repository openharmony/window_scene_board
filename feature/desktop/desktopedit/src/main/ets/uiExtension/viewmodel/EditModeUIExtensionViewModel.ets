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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import { ThemeUtils, SCBDesktopCacheManager, GlobalContext } from '@ohos/frameworkwrapper';
import { NavBarHideAndShowManager } from '@ohos/launchercommon';
import { editModeViewManager } from '../../default/manager/EditModeViewManager';
import { EditModeDockConstants } from '../../default/common/constants/EditModeStyleConstants';
import { editModeDockViewModel } from '../../default/viewmodel/EditModeDockViewModel';
import Want from '@ohos.app.ability.Want';
import IconEditPageConstants from '../../default/common/constants/IconEditPageConstants';

const TAG: string = 'EditModeUIExtensionViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const INVALID_ID: number = -1;
const DELAY_PRELOAD_TIME: number = 300;

/**
 * EditModeUIExtension ViewModel
 */
export class EditModeUIExtensionViewModel {
  private uiExtensionProxy: UIExtensionProxy | undefined;
  private timerId: number = INVALID_ID;

  /**
   * 初始化uiExtensionProxy
   *
   * @param uiExtensionProxy
   */
  public initProxy(uiExtensionProxy: UIExtensionProxy): void {
    this.uiExtensionProxy = uiExtensionProxy;
  }

  /**
   * 接收UIExtension数据
   *
   * @param data UIExtension发的数据
   */
  public onReceiveData(data: Record<string, object | string | number | boolean>, wantData?: Want): void {
    if (!data) {
      return;
    }
    const needAnimation: boolean = wantData?.abilityName === IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME;
    log.showInfo('UIExtensionComponent onReceive data');
    if (needAnimation) {
      // 图标编辑返回、显示导航条，取消应用内导航条色彩模式
      NavBarHideAndShowManager.getInstance().executeCallbackByType(TAG, true);
      GlobalContext.getContext()?.eventHub.emit('AiBarUseAppColor', false);
    }
    if (data['back'] === true) {
      this.cancelDesktopCacheState(data);
      log.showWarn(`onReceiveData, UIExtension back`);
      editModeViewManager.exitUIExtension(false, needAnimation);
      if (this.timerId === INVALID_ID) {
        this.timerId = setTimeout(()=> {
          ThemeUtils.preloadThemeExtAbility(getContext());
          editModeDockViewModel.preloadIconEditPage(EditModeDockConstants.ICON_KEY);
          this.timerId = INVALID_ID;
        }, DELAY_PRELOAD_TIME);
      }
      return;
    }
    if (typeof data['isUseCache'] === 'boolean') {
      SCBDesktopCacheManager.getInstance().setDesktopCacheState(data['isUseCache'], SCBConstants.THEME_EDIT);
      return;
    }
    if (data['apply'] === true) {
      this.cancelDesktopCacheState(data);
      log.showWarn(`onReceiveData, UIExtension apply`);
      editModeViewManager.exitUIExtension(true, needAnimation);
    }
  };

  /**
   * init desktop cache.
   */
  public initDesktopCache(): void {
    SCBDesktopCacheManager.getInstance().setDesktopCacheState(false, SCBConstants.THEME_EDIT);
  }

  /**
   * 给UIExtension发送回调信息
   */
  public sendBackEvent(): void {
    log.showInfo('send sendBackEvent');
    this.uiExtensionProxy?.send({ 'backEvent' : true });
  }

  /**
   * 给UIExtension发送展示消息
   */
  public sendShowEvent(): void {
    log.showInfo('send sendShowEvent');
    this.uiExtensionProxy?.send({ 'showEvent' : true });
  }

  private cancelDesktopCacheState(data: Record<string, object | string | number | boolean>): void {
    if (data['useCache'] === false) {
      SCBDesktopCacheManager.getInstance().setDesktopCacheState(false, SCBConstants.THEME_EDIT);
    }
  }
}

export const editModeUIExtensionViewModel: EditModeUIExtensionViewModel =
  SingletonHelper.getInstance(EditModeUIExtensionViewModel, TAG);