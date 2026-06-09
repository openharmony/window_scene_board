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

import {
  LogDomain,
  LogHelper,
  SingletonHelper,
  AppStorageUtil,
  DataProperty,
  DomainName,
  TraceUtil,
  Trace,
} from '@ohos/basicutils';
import { PluginSlot, DeviceHelper } from '@ohos/frameworkwrapper';
import { ItemUtils } from '@ohos/componenthelper';
import { getSnapshotAndDegree, SnapshotAndDegree } from '../../utils/ColorInvertTool';
import { ColorModeViewData } from './ColorModeViewData';
import { taskpool } from '@kit.ArkTS';
import { UIContext } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { ConfigurationConstant } from '@kit.AbilityKit';
// import { getWithRange } from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubGetWithRange';
import { ColorModeVolumeViewData } from './ColorModeVolumeViewData';
import { ColorModeLiveViewData } from './ColorModeLiveViewData';
import { ColorModeNCViewData } from './ColorModeNCViewData';
import { ScreenSessionAdapter } from '../../adapter/ScreenSessionAdapter';
import { WindowAdapter } from '../../adapter/WindowAdapter';
import { DropDownAdapter } from '../../adapter/DropDownAdapter';

const TAG = 'ColorModeViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const CHANGE_ANIM_DURATION: number = 333;
const SCREENSHOT_WAIT_TIME: number = 300;
const SCREENSHOT_WAIT_TIME_OUT: number = 1000;
// 组件截图起终点
const SNAPSHOT_START_NODE: string = 'OneHandModeBox';
const SNAPSHOT_END_NODE: string = 'SCBDropdownPanel';

export class ColorModeViewModel {
  private viewData: ColorModeViewData | undefined = undefined;
  private volumeViewData: ColorModeVolumeViewData | undefined = undefined;
  private liveViewData: ColorModeLiveViewData | undefined = undefined;
  private ncViewData: ColorModeNCViewData | undefined = undefined;
  private currentColorMode: number = -1;
  private isDone: boolean = false;
  private iotProxy?: UIExtensionProxy;
  private uiContext: UIContext | undefined = undefined;

  public static getInstance(): ColorModeViewModel {
    let colorModeViewModel: ColorModeViewModel = SingletonHelper.getInstance(ColorModeViewModel, TAG);
    return colorModeViewModel;
  }

  public onColorModeChange(mode: number) {
    if (this.currentColorMode === mode) {
      return;
    }
    log.showInfo(`onColorModeChangeWithAnim, mode is ${mode}`);
    this.currentColorMode = mode;
    if (this.viewData == null) {
      this.viewData = new ColorModeViewData();
    }
    this.changeControlCenterMode(mode);
    this.changeOtherModuleMode(mode);
  }

  private changeOtherModuleMode(mode: number) {
    if (mode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.viewData?.changeLightMode();
    } else {
      this.viewData?.changeDarkMode();
    }
  }

  private changeControlCenterMode(mode: number) {
    if (!this.needAnimate()) {
      AppStorageUtil.setOrCreate('colorModeChanging', true, new DataProperty(true, false));
      TraceUtil.startTrace(DomainName.CC, 'colorModeChangingWithoutAnim');
      if (mode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
        this.viewData?.changeLightModeWithAnim();
      } else {
        this.viewData?.changeDarkModeWithAnim();
      }
      TraceUtil.endTrace(DomainName.CC, 'colorModeChangingWithoutAnim');
      AppStorageUtil.setOrCreate('colorModeChanging', false, new DataProperty(true, false));
      return;
    } else {
      this.changeControlCenterModeWithAnim(mode);
    }
  }

  private changeControlCenterModeWithAnim(mode: number) {
    // 根据第一行开关的坐标推断第一行文字所处的区域
    let startX = ItemUtils.getRectById('Ctrl.QuickToggleRow_1').left;
    let startY = ItemUtils.getRectById('Ctrl.QuickToggleRow_1').bottom;
    log.showInfo('startY: ' + startY + 'startX: ' + startX);
    let region: image.Region = {
      x: vp2px(startX) * 0.1,
      y: vp2px(startY) * 0.1,
      size: { height: vp2px(16) * 0.1, width: vp2px(304) * 0.1 }
    };
    TraceUtil.startTrace(DomainName.CC, 'colorModeChanging');
    AppStorageUtil.setOrCreate('colorModeChanging', true, new DataProperty(true, false));
    if (DeviceHelper.isPC()) {
      this.animateTo(mode);
      return;
    }
    setTimeout(() => {
      // 组件截图
      TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_SCREEN_SHOT);
      /*getWithRange(this.getUiContext()?.getComponentSnapshot(), SNAPSHOT_START_NODE, SNAPSHOT_END_NODE, true,
        { scale: 0.1 }).then((pixMap: image.PixelMap) => {
        TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_SCREEN_SHOT);
        this.isDone = false;
        try {
          // 等待背景切换深浅色完成进行截图，根据截图深浅来统一切换整体效果
          taskpool.execute(getSnapshotAndDegree, pixMap, region).then((res: Object) => {
            this.isDone = true;
            let resObject = res as SnapshotAndDegree;
            // 暂时用不到截图，释放内存
            resObject.snapshot.release();
            log.showInfo('getSnapshotAndDegree degree: %{public}d', resObject.degree);
            this.animateTo(mode, resObject.degree);
          }).catch((err: BusinessError) => {
            log.showError(`taskpool.execute error, code=${err?.code} msg=${err?.message}`);
          }).finally(() => {
            pixMap?.release();
          });
        } catch (error) {
          log.showError(`getSnapshotAndDegree error, code=${error?.code} msg=${error?.message}`);
        }
      })*/
    }, SCREENSHOT_WAIT_TIME);
    setTimeout(() => {
      if (this.isDone) {
        log.showInfo('anim has been done, need not do again')
        return;
      }
      // 1秒钟内取色结果还未返回，就忽略取色结果，直接切换整体效果
      this.animateTo(mode);
    }, SCREENSHOT_WAIT_TIME_OUT)
  }

  private animateTo(mode: number, degree?: number) {
    TraceUtil.startTrace(DomainName.CC, 'changeColorModeAnim');
    log.showInfo('start do color mode change animation');
    animateTo({
      curve: Curve.Smooth,
      duration: CHANGE_ANIM_DURATION,
      onFinish: () => {
        TraceUtil.endTrace(DomainName.CC, 'colorModeChanging');
        TraceUtil.endTrace(DomainName.CC, 'changeColorModeAnim');
        AppStorageUtil.setOrCreate('colorModeChanging', false, new DataProperty(true, false));
        AppStorageUtil.setOrCreate('isMarkingRenderGroupOfControl', true, new DataProperty(true, false));
      }
    }, () => {
      if (this.viewData) {
        // 切换模式之前取消节点组标记，避免文字颜色切换无过渡效果
        AppStorageUtil.setOrCreate('isMarkingRenderGroupOfControl', false, new DataProperty(true, false));
        if (mode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
          this.viewData.changeLightModeWithAnim(degree);
        } else {
          this.viewData.changeDarkModeWithAnim(degree);
        }
      }
    });
    log.showInfo('end change mode')
    // 等待控制中心侧UI执行完毕再通知IOT一起做切换深浅动效，否则控制中心会因为UI执行时长波动造成切换不一致
    // 实测IOT添加满18张卡片的情况最坏延迟4帧开始动效，视觉效果上不明显
    this.iotProxy?.send({ 'method': 'changeColorMode', 'param': mode });
    log.showInfo('color mode has been send to iot: %{public}d', mode);
  }

  /**
   * 控制中心不可见时不通过动效过渡颜色
   * @returns
   */
  private needAnimate(): boolean {
    return DropDownAdapter.isDropDownShow() ||
      (DeviceHelper.isPC() && WindowAdapter.isShowingSync(PluginSlot.SLOT_STATUS_CONTROL_CENTER));
  }

  public getViewData(): ColorModeViewData {
    if (this.viewData == null) {
      this.viewData = new ColorModeViewData();
      return this.viewData;
    } else {
      return this.viewData;
    }
  }

  public getVolumeViewData(): ColorModeVolumeViewData {
    if (this.volumeViewData == null) {
      this.volumeViewData = new ColorModeVolumeViewData();
      return this.volumeViewData;
    } else {
      return this.volumeViewData;
    }
  }

  public getLiveViewData(): ColorModeLiveViewData {

    if (this.liveViewData == null) {
      this.liveViewData = new ColorModeLiveViewData();
      return this.liveViewData;
    } else {
      return this.liveViewData;
    }
  }

  public getNCViewData(): ColorModeNCViewData {
    if (this.ncViewData == null) {
      this.ncViewData = new ColorModeNCViewData();
      return this.ncViewData;
    } else {
      return this.ncViewData;
    }
  }

  public setIotProxy(iotProxy: UIExtensionProxy) {
    this.iotProxy = iotProxy;
  }

  public getUiContext(): UIContext | undefined {
    return this.uiContext;
  }

  public setUiContext(uiContext: UIContext): void {
    this.uiContext = uiContext;
  }
}