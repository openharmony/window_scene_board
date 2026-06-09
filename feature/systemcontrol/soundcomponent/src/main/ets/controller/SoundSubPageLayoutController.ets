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
  SingletonHelper
} from '@ohos/basicutils';
import {
  obtainLocalEvent,
  obtainStartAbilityWithWant,
  sEventManager,
} from '@ohos/frameworkwrapper';
import { ExtAppConstants } from '@ohos/commonconstants';
import { CurrentMemScene, PerformanceReporter } from '@ohos/frameworkcommon';
import toggleController from './SoundToggleController';
import SoundReporterController from './SoundReporterController';
import { AudioHelper } from '../utils/AudioHelper';
import connection from '@ohos.bluetooth.connection';
import { BusinessError } from '@kit.BasicServicesKit';
import { BaseController, CommonData } from '@ohos/controlcentercommon/Index';
import { performanceMonitor } from '@kit.ArkUI';
import { SliderButtonShareData } from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonViewData';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';

/**
 * 二级页面状态
 */
export enum SubPageStatus {
  DETAIL,
  NOISECONTROL,
  SPATIAL
}

const TAG = 'SoundSubPageLayoutController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 入口到二级页面状态
 */
export enum PageMode {
  NONE,
  DETAIL
}

/**
 * 二级页被拉起方式，横向进度条 or 竖向进度条
 */
export enum SubPageMode {
  HORIZONTAL,
  VERTICAL
}

export interface BottomBtnPara {
  icon?: ResourceStr;
  selectedIcon?: ResourceStr;
  selectedCanvas?: object;
  // value?: NoiseSwitch | SpatialState;
  value?: ESObject;
  label: ResourceStr;
  subLabel?: ResourceStr;
  isSelected?: boolean;
  des: string;
}

class SoundSubPageLayoutController extends BaseController<CommonData> {
  private pageMode: PageMode = PageMode.NONE;
  private subpageMode: SubPageMode = SubPageMode.HORIZONTAL;
  public noiseControlConfig: BottomBtnPara[] = [];
  public spatialConfig: BottomBtnPara[] = [];

  getData(): CommonData {
    return new CommonData();
  }
  isAvailable(): boolean {
    return true;
  }

  public isHorizontal(): boolean {
    return this.subpageMode === SubPageMode.HORIZONTAL;
  }

  /**
   * 获取噪声控制2态配置数据
   * @returns 噪声控制UI配置 config
   */
  getNoiseControlTwoConfig(): BottomBtnPara[] {
    // if (this.noiseControlConfig.length === NoiseControlSupportMode.TWO_MODE) {
    //   return this.noiseControlConfig;
    // }
    this.noiseControlConfig = [
      {
        label: $r('app.string.base_none'),
        // value: NoiseSwitch.NOISE_CANCELING_OFF,
        icon: $r('app.media.ic_noise_control_0'),
        des: 'noise_off',
      },
      {
        label: $r('app.string.noise_on'),
        // value: NoiseSwitch.NOISE_CANCELING_ON,
        icon: $r('app.media.ic_noise_control_2'),
        des: 'noise_cancel',
      }
    ];
    toggleController.loadLottieData('noise_cancel.json', (data) => {
      this.noiseControlConfig[1].selectedCanvas = data;
    });
    return this.noiseControlConfig;
  }

  /**
   * 获取噪声控制3态配置数据
   *
   * @returns 噪声控制UI配置 config
   */
  getNoiseControlThreeConfig(): BottomBtnPara[] {
    // if (this.noiseControlConfig.length === NoiseControlSupportMode.THREE_MODE) {
    //   return this.noiseControlConfig;
    // }
    this.noiseControlConfig = [
      {
        label: $r('app.string.base_none'),
        // value: NoiseSwitch.NOISE_CANCELING_OFF,
        icon: $r('app.media.ic_noise_control_0'),
        des: 'noise_off',
      },
      {
        label: $r('app.string.base_pass_through'),
        // value: NoiseSwitch.AWARENESS,
        icon: $r('app.media.ic_noise_control_1'),
        selectedIcon:  $r('app.media.ic_noise_control_1_selected'),
        des: 'noise_awareness',
      },
      {
        label: $r('app.string.noise_reduction'),
        // value: NoiseSwitch.NOISE_CANCELING_ON,
        icon: $r('app.media.ic_noise_control_2'),
        des: 'noise_cancel',
      }
    ];
    toggleController.loadLottieData('noise_off.json', (data) => {
      this.noiseControlConfig[0].selectedCanvas = data;
    });
    toggleController.loadLottieData('noise_awareness.json', (data) => {
      this.noiseControlConfig[1].selectedCanvas = data;
    });
    toggleController.loadLottieData('noise_cancel.json', (data) => {
      this.noiseControlConfig[2].selectedCanvas = data;
    });
    return this.noiseControlConfig
  }

  /**
   * 高清空间音频UI， 2态配置
   */
  getSpatialTwoConfig(): BottomBtnPara[] {
    // if (this.spatialConfig.length === SpatialSupportMode.TWO_MODE + 1) {
    //   return this.spatialConfig;
    // }
    this.spatialConfig = [
      {
        label: $r('app.string.base_none'),
        // value: SpatialState.OFF,
        icon: $r('app.media.ic_audio_spatial_0'),
        des: 'spatial_off',
      },
      {
        label: $r('app.string.spatial_audio_fixed'),
        // value: SpatialState.FIX,
        icon: $r('app.media.ic_audio_spatial_1'),
        des: 'spatial_fix',
      }
    ];
    toggleController.loadLottieData('spatial_fix.json', (data) => {
      this.spatialConfig[1].selectedCanvas = data;
    });
    return this.spatialConfig
  }

  /**
   * 高清空间音频UI， 3态配置
   */
  getSpatialThreeConfig(): BottomBtnPara[] {
    // if (this.spatialConfig.length === SpatialSupportMode.THREE_MODE + 1) {
    //   return this.spatialConfig;
    // }
    this.spatialConfig = [
      {
        label: $r('app.string.base_none'),
        // value: SpatialState.OFF,
        icon: $r('app.media.ic_audio_spatial_0'),
        des: 'spatial_off',
      },
      {
        label: $r('app.string.spatial_audio_fixed'),
        // value: SpatialState.FIX,
        icon: $r('app.media.ic_audio_spatial_1'),
        des: 'spatial_fix',
      },
      {
        label: $r('app.string.spatial_audio_follow'),
        // value: SpatialState.TRACK,
        icon: $r('app.media.ic_audio_spatial_2'),
        des: 'spatial_track',
      }
    ];
    toggleController.loadLottieData('spatial_off.json', (data) => {
      this.spatialConfig[0].selectedCanvas = data;
    });
    toggleController.loadLottieData('spatial_fix.json', (data) => {
      this.spatialConfig[1].selectedCanvas = data;
    });
    toggleController.loadLottieData('spatial_track.json', (data) => {
      this.spatialConfig[2].selectedCanvas = data;
    });
    return this.spatialConfig
  }

  /**
   * 隐藏二级页面窗口
   *
   */
  public hideWindow() {
    log.showInfo(`SubLayoutController hideWindow`);
    if (this.pageMode === PageMode.NONE) {
      return;
    }
    if (SliderButtonShareData.getInstance().isDragging) {
      log.showInfo('slider is dragging, not hide window');
      return;
    }
    this.pageMode = PageMode.NONE;
    PerformanceReporter.getInstance().reportExitMemScene(CurrentMemScene.SCENE_SOUND);
    sEventManager.publish(obtainLocalEvent('ControlCenterState', 0));
    performanceMonitor.begin('EXIT_CC_SUB_VOLUME_ANI', performanceMonitor.ActionType.LAST_UP);
  }

  /**
   * 展示二级页面窗口
   *
   */
  public showWindow(isHorizontal: boolean = true) {
    log.showInfo(`SubLayoutController showWindow`)
    this.pageMode = PageMode.DETAIL;
    this.subpageMode = isHorizontal ? SubPageMode.HORIZONTAL : SubPageMode.VERTICAL;
    PerformanceReporter.getInstance().reportEnterMemScene(CurrentMemScene.SCENE_SOUND);
    toggleController.handleOnControlCenterWithScreenLockForUIE(() => {
      sEventManager.publish(obtainLocalEvent('ControlCenterState', 6));
      performanceMonitor.begin('INTO_CC_SUB_VOLUME_ANI', performanceMonitor.ActionType.LAST_UP);
      SoundReporterController.clickVoiceButtonReport(AudioHelper.getInstance().outputDevice);
    }, true);
  }

  public goVolumeSetting(): void {
    log.showInfo(`goVolumeSetting`);
    this.handleGoSettingWithScreenLock(() => {
      EventManagerAdapter.startAbility(obtainStartAbilityWithWant({
        bundleName: ExtAppConstants.ABILITY_SETTINGS_BUNDLENAME,
        abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
        uri: 'volume_settings',
        moduleName: 'phone'
      }));
      DropDownPanelManager.hideWindowDirectly();
    })
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
    log.showInfo(`SubLayoutController onBackPress sound ${this.pageMode} `)
    if (this.pageMode === PageMode.NONE || SliderButtonShareData.getInstance().isDragging) {
      return false;
    }
    this.hideWindow();
    return true;
  }

  /**
   * 同步获取设备的名称
   * @param mac 设备mac地址，如果不传，则默认为当前设备mac地址
   * @returns 指定设备的名称
   */
  public getDeviceNameSync(mac: string): string {
    try {
      log.showInfo(`getDeviceNameSync ${connection.getRemoteDeviceName(mac)}`)
      return connection.getRemoteDeviceName(mac);
    } catch (err) {
      log.showInfo(`getDeviceNameSync failed! err = ${(err as BusinessError).code} ${(err as BusinessError).message}`);
    }
    return '';
  }

  /**
   * 跳转音频管家
   */
  goToAudioAccessoryManager(mac: string) {
    if (!mac) {
      return;
    }
    const want = {
      bundleName: ExtAppConstants.PKG_AUDIO_ACCESSORY_MANAGER,
      abilityName: ExtAppConstants.ABILITY_AUDIO_ACCESSORY_MANAGER,
      moduleName: 'phone',
      parameters: {
        mac: mac,
        'ohos.aafwk.param.callerBundleName': 'com.ohos.sceneboard'
      }
    } as Want;
    EventManagerAdapter.startAbility(obtainStartAbilityWithWant(want));
  }

}

export const soundSubPageController = SingletonHelper.getInstance(SoundSubPageLayoutController, TAG);
