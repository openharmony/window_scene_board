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
import { configPolicy, systemParameterEnhance } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import fs from '@ohos.file.fs';
import { Singleton } from './Singleton';

const TAG = 'SystemUICcmConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

// 实况控帧策略
export enum ScenePolicy {
  // 供nova机型将实况窗动效控制为高帧率
  BACK_DESKTOP = 'BACK_DESKTOP'
}

export class SystemUICcmConfig {
  @Singleton.decorate()
  public static get instance(): SystemUICcmConfig { return new SystemUICcmConfig(); }

  /**
   * 是否启用实况2.0功能
   */
  public isEnabledLive2: boolean = false;

  /**
   * 是否启用静态切分
   */
  public isEnabledWorker: boolean = false;

  /**
   * 是否启用通知中心2.0
   */
  public isEnabledNotification2: boolean = true;

  public holeNumInfo: string[] = [];

  public readonly liveConfig: LiveConfig = new LiveConfig();

  private constructor() {
    try {
      this.isEnabledLive2 = systemParameterEnhance.getSync('persist.systemui.live2', 'false') === 'true';
      log.showInfo(`isEnabledLive2: ${this.isEnabledLive2}`);
      this.isEnabledWorker = systemParameterEnhance.getSync('persist.systemui.worker2', 'false') === 'true';
      log.showInfo(`isEnabledWorker: ${this.isEnabledWorker}`);
      // 获取设备物理挖孔数量信息
      const holeNumConfig = systemParameterEnhance.getSync('persist.systemui.hole_count', '0');
      log.showInfo(`holeNumConfig: ${holeNumConfig}`);
      this.holeNumInfo = holeNumConfig.split(',');
    } catch (e) {
      log.error('Init systemui ccm error:', e);
    }
    try {
      this.loadLiveConfig();
    } catch (e) {
      log.error('Init live config ccm error:', e);
    }
  }

  /**
   * 实况配置
   */
  private async loadLiveConfig(): Promise<void> {
    try {
      const configPaths = await configPolicy.getCfgFiles('etc/systemui/liveview_config.json');
      if (configPaths.length === 0) {
        log.showWarn(`Not found config files for etc/systemui/liveview_config.json`);
        return;
      }

      for (let path of configPaths) {
        const liveConfig = JSON.parse(await fs.readText(path)) as LiveConfig;
        Object.assign(this.liveConfig, liveConfig);
      }
      log.showInfo(`Load live config end, capsuleLight: ${this.liveConfig.showLightWhenExpandCapsule},
        cardLight: ${this.liveConfig.showLightWhenExpandCard},
        statusBarAnimation: ${this.liveConfig.blurStatusBarWhenExpandCapsule},
         metaBallLight: ${this.liveConfig.showLightWhenFusionMetaball},
         frameRateCtrlScene: ${this.liveConfig.frameRateCtrlScene}`);
    } catch (e) {
      log.error('Load liveview_config.json failed:', e);
    }
  }
}

class LiveConfig {
  /**
   * 胶囊弹出扫光动效控制，0：关闭，1：开启。默认值为1
   */
  public showLightWhenExpandCapsule?: string;

  /**
   * 卡片展开流光动效控制，0：关闭，1：开启。默认值为1
   */
  public showLightWhenExpandCard?: string;

  /**
   * 是否开启在胶囊出场时的胶囊扫光效果，0：关闭，1：开启。默认值为1
   */
  public blurStatusBarWhenExpandCapsule?: string;

  /**
   * 是否开启在融球时的辉光效果，0：关闭，1：开启。默认值为0
   */
  public showLightWhenFusionMetaball?: string = '0';
  /**
   * 是否开启天气动效，0：关闭，1：开启。默认值为1
   */
  public showWeatherAnimationWhenExpandCard?:string;

  /**
   * 帧率控制场景，默认为空数组代表跟随整机帧率策略，赋值为'BACK_DESKTOP'代表供nova机型将实况窗动效控制为高帧率
   */
  public frameRateCtrlScene: ScenePolicy[] = [];

  /**
   * 是否开启胶囊扫光动效
   * @returns
   */
  isShowLightWhenExpandCapsule(): boolean {
    return !this.showLightWhenExpandCapsule || this.showLightWhenExpandCapsule === '1';
  }

  /**
   * 是否关闭流光效果
   * @returns
   */
  isDisableLightWhenExpandCard(): boolean {
    return this.showLightWhenExpandCard === '0';
  }

  /**
   * 是否开启卡片全部流光效果
   * @returns
   */
  isShowLightWhenExpandCard(): boolean {
    return !this.showLightWhenExpandCard || this.showLightWhenExpandCard === '1';
  }

  /**
   * 是否开启状态栏联动动效
   * @returns
   */
  isBlurStatusBarWhenExpandCapsule(): boolean {
    return !this.blurStatusBarWhenExpandCapsule || this.blurStatusBarWhenExpandCapsule === '1';
  }

  /**
   * 是否开启融球辉光动效
   * @returns
   */
  isShowLightWhenFusionMetaball(): boolean {
    return !this.showLightWhenFusionMetaball || this.showLightWhenFusionMetaball === '1';
  }

  /**
   * 是否开启天气动效
   * @returns
   */
  isShowWeatherAnimationWhenExpandCard(): boolean {
    return !this.showWeatherAnimationWhenExpandCard || this.showWeatherAnimationWhenExpandCard === '1';
  }
}