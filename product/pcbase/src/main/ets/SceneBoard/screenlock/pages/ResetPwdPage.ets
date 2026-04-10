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
import { SystemParameterUtil } from '@ohos/launchercommon/src/main/ets/utils/SystemParameterUtil';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import screenSessionManager from '@ohos.screenSessionManager';
import Constants from '../common/Constants';

const TAG: string = 'ScreenLock-ResetPasswordPage';
const log: Logger = Logger.getLogHelper(LogDomain.KG);
const RESET_PASSWORD_MOD = 'persist.pc_security.reset_password_mod';
const DEFAULT_RESET_PASSWORD_MOD_VALUE = '0';
const BUNDLE_NAME = 'com.openharmony.fileencryptionmanage';
const ABILITY_NAME = 'EntryAbilityResetPwd';

@Component
export default struct ResetPwdPage {
  private proxy: UIExtensionProxy | null = null;
  @Link pwdPageShow: boolean;

  private updateResetPwdMod(): void {
    let resetPwdMod = SystemParameterUtil.getSync(RESET_PASSWORD_MOD, DEFAULT_RESET_PASSWORD_MOD_VALUE);
    this.pwdPageShow = resetPwdMod !== DEFAULT_RESET_PASSWORD_MOD_VALUE;
    if (resetPwdMod === DEFAULT_RESET_PASSWORD_MOD_VALUE) {
      this.lockScreenLandscapeStatus(false);
    }
  }

  private lockScreenLandscapeStatus(isLock: boolean): void {
    const screenSession = SCBScreenSessionManager.getInstance()?.getMainScreenSession();
    screenSession.setEnableRotate(!isLock, 'resetPwdPage');
    screenSessionManager.setLandscapeLockStatus(isLock);
  }

  build() {
    UIExtensionComponent({
      bundleName: BUNDLE_NAME,
      abilityName: ABILITY_NAME,
      parameters: {
        'ability.want.params.uiExtensionType': 'sys/commonUI',
      }
    })
      .id(Constants.PC_COMPONENT_ID_RESET_PASSWORD_UEC)
      .width('100%')
      .height('100%')
      .onReceive((data) => {
        log.info(TAG, 'onReceive');
      })
      .onRemoteReady((proxy) => {
        log.info(TAG, 'onRemoteReady')
        this.proxy = proxy
        this.proxy.on('syncReceiverRegister', syncRegisterCallback);
        this.lockScreenLandscapeStatus(true);
        let result = focusControl.requestFocus(Constants.PC_COMPONENT_ID_RESET_PASSWORD_UEC);
        log.info(TAG, `onRemoteReady requestFocus result ${result}`);
      })
      .onTerminated((terminationInfo: TerminationInfo) => {
        log.info(TAG, 'onTerminated');
        this.updateResetPwdMod();
        let result = focusControl.requestFocus(Constants.PC_COMPONENT_ID_PASSWORD);
        log.info(TAG, `onTerminated requestFocus result ${result}`);
      })
      .onBlur(() => {
        log.info(TAG, 'onBlur');
        let result = focusControl.requestFocus(Constants.PC_COMPONENT_ID_PASSWORD);
        log.info(TAG, `onBlur requestFocus result ${result}`);
      })
  }
}

function syncRegisterCallback(proxy: UIExtensionProxy) {
  log.info('on invoke syncRegisterCallback, type is syncReceiverRegister');
}