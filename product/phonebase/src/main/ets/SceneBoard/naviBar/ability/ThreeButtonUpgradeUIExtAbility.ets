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

import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import type UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import type Want from '@ohos.app.ability.Want';
import { GlobalContext } from '@ohos/frameworkwrapper'
import { LogDomain, LogHelper } from '@ohos/basicutils';
import contextConstant from '@ohos.app.ability.contextConstant';
import type ctx from '@ohos.app.ability.common';
import { ThreeButtonUpgradeConstants } from '../ThreeButtonUpgradeConstants';
import { ConfigurationConstant } from '@kit.AbilityKit';

const TAG: string = 'ThreeButtonUpgradeUIExtAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 拉起三键导航升级向导页面的UIExtensionAbility
 */
export default class ThreeButtonUpgradeUIExtAbility extends UIExtensionAbility {
  onCreate(): void {
    log.showInfo('onCreate');
    this.context.area = contextConstant.AreaMode.EL1;
    GlobalContext.getInstance().setObject(ThreeButtonUpgradeConstants.CONTEXT_KEY, this.context);
    GlobalContext.setContext(GlobalContext.getInstance()
      .getObject(ThreeButtonUpgradeConstants.CONTEXT_KEY) as ctx.ServiceExtensionContext);
  }

  onForeground(): void {
    log.showInfo('onForeground');
  }

  onBackground(): void {
    log.showInfo('onBackground');
  }

  onDestroy(): void {
    log.showInfo('onDestroy');
    GlobalContext.getInstance().removeObject(ThreeButtonUpgradeConstants.CONTEXT_KEY);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    log.showInfo(`onCreate want: ${want.abilityName}`);
    try {
      this.context?.getApplicationContext()?.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
    } catch (error) {
      log.showWarn(`${TAG} setColorMode error ${error?.code}`);
    }

    GlobalContext.getInstance().setObject(ThreeButtonUpgradeConstants.THREE_BUTTON_UPGRADE_WANT, want);
    let para: Record<string, UIExtensionContentSession> = {
      'session': session
    };
    let storage: LocalStorage = new LocalStorage(para);
    try {
      session?.loadContent(ThreeButtonUpgradeConstants.UPGRADE_VIEW_PATH, storage);
      // 设置window颜色和透明度
      session?.setWindowBackgroundColor(ThreeButtonUpgradeConstants.WINDOW_COLOR);
      log.showInfo('Succeeded in loading the content');
    } catch (err) {
      log.showError(`onSessionCreate Fail Cause: ${err}`);
    }
  }

  onSessionDestroy(session: UIExtensionContentSession): void {
    log.showInfo('onSessionDestroy');
    GlobalContext.getInstance().removeObject(ThreeButtonUpgradeConstants.THREE_BUTTON_UPGRADE_WANT);
  }
};