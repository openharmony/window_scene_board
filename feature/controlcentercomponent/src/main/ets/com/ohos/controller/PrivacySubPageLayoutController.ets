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

// import privacyIndicatorManager from '@hms.security.privacyIndicatorManager';
import { SingletonHelper, LogHelper, LogDomain } from '@ohos/basicutils';
import { obtainLocalEvent, sEventManager } from '@ohos/frameworkwrapper';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ControlCenterHiSysEventUtil } from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';
import { onAsyncReceiverRegister } from '../common/UIExtensionProxyHelper';
import sControlCenterBaseController from './ControlCenterBaseController';

const TAG: string = 'Ctrl.PrivacySubLayoutController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export enum PageMode {
  NONE,
  DETAIL
}

class PrivacySubLayoutController {
  private pageMode: PageMode = PageMode.NONE;

  public getPageMode(): PageMode {
    return this.pageMode;
  }

  public onRemoteReady(proxy: UIExtensionProxy | null): void {
    let privacyData: ESObject[] = AppStorage.get('privacyData') as Array<ESObject>;
    if (proxy === null) {
      return;
    }
    log.showInfo(`onRemoteReady privacySubpageData num ${privacyData.length}`)
    onAsyncReceiverRegister(proxy, (p: UIExtensionProxy) => {
      p?.send({
        'privacySubpageData': {
          privacyData: JSON.stringify(privacyData)
        }
      });
    })
  }

  /**
   * pc隐私窗口remoteReady回调
   */
  public onRemoteReadyPC(proxy: UIExtensionProxy | null, maxWindowHeight: number): void {
    if (proxy === null) {
      return;
    }
    let privacyData: ESObject[] = AppStorage.get('privacyData') as ESObject[];
    onAsyncReceiverRegister(proxy, (p: UIExtensionProxy) => {
      p?.send({
        'privacySubpageData': {
          privacyData: JSON.stringify(privacyData),
          maxWindowHeight: maxWindowHeight,
        }
      });
    })
  }

  /**
   * 隐藏二级页面窗口
   *
   */
  public hideWindow() {
    this.pageMode = PageMode.NONE;
    log.showInfo('privacy subLayout hideWindow');
    sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.MAIN_LAYOUT));
  }

  /**
   * 展示二级页面窗口
   *
   */
  public showWindow() {
    ControlCenterHiSysEventUtil.reportCCClickPrivacySensor({
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
    })
    this.pageMode = PageMode.DETAIL;
    log.showInfo('privacy subLayout showWindow');
    sControlCenterBaseController.handleOnControlCenterWithScreenLockForUIE(() => {
      sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.PRIVACY_SUB_PAGE));
    }, true);
  }

  /**
   * 息屏时关闭窗口
   */
  public onScreenOff() {
    this.hideWindow();
  }

  /**
   * 返回键，关闭窗口
   *
   * @return true 处理了返回事件，false 未消费事件
   */
  public onBackPress(): boolean {
    if (this.pageMode === PageMode.NONE) {
      return false;
    }
    this.hideWindow();
    return true;
  }
}

export let sPrivacySubLayoutController: PrivacySubLayoutController =
  SingletonHelper.getInstance(PrivacySubLayoutController, TAG);
