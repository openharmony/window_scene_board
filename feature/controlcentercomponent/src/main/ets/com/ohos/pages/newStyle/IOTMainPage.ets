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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DropDownEvent, DeviceHelper } from '@ohos/frameworkwrapper';
import DropDownPanelManager, { PanelDismissReason } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import sControlCenterBaseController from '../../controller/ControlCenterBaseController';
import { ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { sIOTSubPageLayoutController } from '../../controller/IOTSubPageLayoutController';
import { ControlCenterAnimationData } from '../../model/ControlCenterAnimationData';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { mediaquery } from '@kit.ArkUI';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import image from '@ohos.multimedia.image';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import Prompt from '@ohos.promptAction';
import { PromptAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/PromptAdapter';

const TAG = 'Ctrl.IOTMainPage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const DELAY_SHOW_EXTENSION_TIME: number = 200;

@Component
export default struct IOTMainPage {
  @ObjectLink animationData: ControlCenterAnimationData;
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;
  @Consume uiExtProxy?: UIExtensionProxy;
  @Link iotHeight: number;
  @Link isIotServiceAlive: boolean;
  @State showIotExtension: boolean = true;
  @State cachePixMap: image.PixelMap | undefined = undefined;
  @Prop iotDeviceList: number[];
  @Link @Watch('updateshowIot') showIOt: boolean;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @StorageLink('isLandscape') @Watch('onOrientationChanged') isLandscape: boolean = false;
  @State columnSpace: number = ResUtils.getNumber($r('app.float.Control_center_mediaAndWifiBlue_spaceBetween'));
  private lastIsDark: boolean = false;
  private changeExtProxy?: (uiExtProxy?: UIExtensionProxy) => void;
  private updateIotDevice?: (iotDeviceList: number[]) => void;
  private dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear showIOt ${this.showIOt}`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
  }

  private updateshowIot() {
    if (!this.showIOt) {
      this.showIotExtension = false;
    } else {
      this.iotHeight =
        this.iotDeviceList.length > 0 ? Math.floor((this.iotDeviceList.length + 1) / 2) * (64 + 16) - 16 : 0;
    }
    if (this.showIOt && this.lastIsDark != mediaquery.matchMediaSync('(dark-mode: true)').matches) {
      this.showIotExtension = true;
    }
    log.showInfo(`updateshowIOtdeviceCache.iotDeviceList.length ${this.iotDeviceList.length}`);
  }

  /**
   * 横竖屏切换回调
   */
  onOrientationChanged() {
    log.showInfo(`onOrientationChanged ${this.isLandscape}`);
  }
  
  private releaseIot() {
    this.iotDeviceList = [];
    this.cachePixMap = undefined;
    this.iotHeight = 0;
    this.isIotServiceAlive = false;
    this.uiExtProxy = undefined;
    this.changeExtProxy?.(undefined);
  }

  private iotShowToast(msg: string): void {
    PromptAdapter.showToast(msg);
  }

  public onIotMessage = (data: object): void => {
    let obj: object;
    if (typeof data === 'string') {
      obj = JSON.parse(data);
    } else {
      obj = data;
    }
    let methodObj: string = obj['method'];
    log.showInfo(`onReceive ${methodObj}`);
    if (methodObj == 'setIotAbilityHeight') {
      if (Number(obj['height']) !== this.iotHeight) {
        this.iotHeight = Number(obj['height']);
        log.showInfo(`showIotExtension change height`);
        this.showIotExtension = true;
      } else {
        this.iotHeight = Number(obj['height']);
        setTimeout(() => {
          if (this.showIOt) {
            log.showInfo(`showIotExtension`);
            this.showIotExtension = true;
          }
          }, DELAY_SHOW_EXTENSION_TIME);
      }
      log.showInfo(`new iot height ${this.iotHeight}`);
    } else if (methodObj == 'jumpToIotDeviceDetail' && this.dropDownEvent.progress === 1) {
      sControlCenterBaseController.handleOnControlCenterWithScreenLock((): void => {
        sIOTSubPageLayoutController.showDetail(obj?.['param']);
      })
    } else if (methodObj == 'showToast') {
      let msg = String(obj['message']);
      this.iotShowToast(msg);
    } else if (methodObj == 'sendScale') {
      let px = vp2px(1);
      this.uiExtProxy?.send({ 'method': 'defaultScaledDensity', 'param': px, });
    } else if (methodObj == 'closeControlCenter') {
      DropDownPanelManager.setDismissReason(PanelDismissReason.CLICK_BLANK);
      DropDownPanelManager.animToDismiss();
    } else if (methodObj == 'deviceSize') {
      if (!this.showIotExtension) {
        log.showInfo(` deviceSize showIotExtension is false`);
        return;
      }
      if (Number(obj['param']) == 0) {
        this.cachePixMap = undefined;
      }
      this.lastIsDark = mediaquery.matchMediaSync('(dark-mode: true)').matches;
      componentSnapshot.get('iotRoot')
        .then((pixmap: image.PixelMap) => {
          this.cachePixMap = pixmap
        }).catch((err: Error) => {
        log.showInfo(`error get iotRoot ${err}`);
      })
      this.iotDeviceList = Array.from(Array(Number(obj['param'])).keys());
      this.updateIotDevice?.(this.iotDeviceList);
      log.showInfo(`deviceCache.iotDeviceList.length ${this.iotDeviceList.length}`);
    }
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      this.iotCache()
      if (this.showIOt) {
        UIExtensionComponent({
          bundleName: 'com.ohos.ailifesvc',
          abilityName: 'IotDeviceAbility',
          parameters: { 'ability.want.params.uiExtensionType': 'sys/commonUI' }
        },
          { dpiFollowStrategy: DpiFollowStrategy.FOLLOW_HOST_DPI })
          .id('iotRoot')
          .height('100%')
          .width('100%')
          .opacity(this.showIotExtension ? 1 : 0)
          .onReceive(this.onIotMessage)
          .onRemoteReady((proxy) => {
            // 通信接口(双向通信)
            this.uiExtProxy = proxy;
            this.changeExtProxy?.(proxy);
            DropDownPanelManager.setIotProxy(this.uiExtProxy);
            ColorModeViewModel.getInstance().setIotProxy(this.uiExtProxy);
            log.showInfo(`IotUiExtProxy: ${this.uiExtProxy}`);
          })
          .onRelease((data: number) => {
            log.showInfo(`IotDeviceAbility released, code: ${data}`);
            this.releaseIot();
          })
          .onError((e) => {
            this.releaseIot();
            log.showInfo(`IotDeviceAbility onError, code: ${e?.code}`);
          })
          .onTerminated((t: TerminationInfo) => {
            this.releaseIot();
            log.showInfo(`IotDeviceAbility onTerminated, code: ${t?.code}`);
          })
          .accessibilityUseSamePage(AccessibilitySamePageMode.FULL_SILENT)
      }
    }
    .focusable(false)
    .opacity(this.animationData?.opacity)
    .scale({
      x: this.animationData?.scale,
      y: this.animationData?.scale,
      centerY: 0
    })
    .height('100%')
    .width('100%')
    .translate({ y: this.animationData?.itemTranslate + Math.max(this.animationData?.translate, 0) })
  }

  @Builder
  iotCache() {
    Grid() {
      ForEach(this.iotDeviceList, (device: number) => {
        GridItem() {
          Row() {
          }
          .backgroundColor($r('app.color.grid_crad_background'))
          .backgroundBrightness({
            rate: this.colorModeViewData.commonDefaultRate,
            lightUpDegree: this.colorModeViewData.commonDefaultDegree,
          })
          .width('100%')
          .height(64)
          .borderRadius(32)
        }
        .clip(false)

      }, (device: number, index): string => {
        return String(device);
      })
    }
    .visibility(this.showIotExtension ? Visibility.None : Visibility.Visible)
    .rowsGap(16)
    .columnsGap(this.columnSpace)
    .columnsTemplate('1fr 1fr')
    .height('100%')
    .width('100%')
    .clip(false)

    Image(this.cachePixMap)
      .height('100%')
      .width('100%')
      .visibility(this.showIotExtension ? Visibility.None : Visibility.Visible)
  }

}

interface ClassTargetInterface<T> {
  createClassTarget: () => T;
}