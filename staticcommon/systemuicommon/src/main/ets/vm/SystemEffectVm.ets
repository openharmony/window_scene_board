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
import { VisualEffectConstants } from '@ohos/commonconstants';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { RssNotifyEvent, CommonComponent } from '@ohos/frameworkwrapper';
import { ClickNotificationErrorCode, ClickNotificationMaintenance } from '../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../maintenance/StatisticsConstants';
import { ThreadSync } from '../messageChannel/ThreadSync';
import { InnerEventUtil } from '../utils/InnerEventUtil';
import { Singleton } from '../utils/Singleton';
import { SystemUICcmConfig } from '../utils/SystemUICcmConfig';

const TAG = 'SystemEffectVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ThreadSync.VmDecorator
@ObservedV2
export class SystemEffectVm {
  @Singleton.decorate()
  public static get instance(): SystemEffectVm {
    return new SystemEffectVm();
  }

  @Trace public isRealtimeBlur: boolean = true;
  @Trace public showLightWhenExpandCapsule: boolean = true;
  @Trace public showLightWhenExpandCard: boolean = true;
  @Trace public blurStatusBarWhenExpandCapsule: boolean = true;
  @Trace public showLightWhenFusionMetaball: boolean = true;

  @Trace public isBrightnessDisable: boolean = false;

  public init(): void {
    InnerEventUtil.on(RssNotifyEvent, this.RssNotifyEvent.bind(this));
    this.isBrightnessDisable =
      SCBVisualEffectMgr.getFeatureParam(VisualEffectConstants.NTF_BRIGHTENS_DISABLE) === 'true';
  }

  private RssNotifyEvent(event: RssNotifyEvent): void {
    try {
      const parseResult = event.component as SceneboardComponent;
      const isRealTimeStr = parseResult?.sceneboard?.liveview?.isRealtimeBlur;
      if (isRealTimeStr === undefined) {
        log.showError(`rssStatusChange isRealtimeBlur undefined`);
        return;
      }
      if (isRealTimeStr === 'true') {
        this.isRealtimeBlur = true;
        ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.FULL_MODE, {
          clickRegion: ClickRegion.UI_LITE_MODE,
        });
        log.showInfo(`rssStatusChange isRealtimeBlur ${isRealTimeStr}`);
        return;
      }
      this.parseSystemuiLive2(parseResult);
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.LITE_MODE, {
        clickRegion: ClickRegion.UI_LITE_MODE,
      });
      log.showInfo(`animPolicy parse end, isRealtimeBlur: ${this.isRealtimeBlur} showLightWhenExpandCapsule: ${this.showLightWhenExpandCapsule},
      showLightWhenExpandCard ${this.showLightWhenExpandCard} isBlurStatusBarWhenExpandCapsule: ${this.blurStatusBarWhenExpandCapsule} isShowLightWhenFusionMetaball: ${this.showLightWhenFusionMetaball}`)
    } catch (error) {
      log.showError(`animPolicy parse error: ${error}`);
    }
  }

  /**
   * 过热/开启省电模式，开启lite档
   * @returns
   */
  public isLiteMode(): boolean {
    return !this.isRealtimeBlur;
  }

  /**
   * 过热开启省电模式/CCM禁用提亮开启, 关闭提亮按压
   * @returns
   */
  public isCloseBrightness(): boolean {
    log.showInfo(`isBrightnessDisable ${this.isBrightnessDisable}`);
    return this.isBrightnessDisable;
  }

  /**
   * 是否开启胶囊弹出扫光动效
   */
  public isShowLightWhenExpandCapsule(): boolean {
    if (this.isRealtimeBlur) {
      return SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule();
    }
    return this.showLightWhenExpandCapsule;
  }

  /**
   * 是否开启卡片展开流光动效
   */
  public isShowLightWhenExpandCard(): boolean {
    if (this.isRealtimeBlur) {
      return SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCard();
    }
    return this.showLightWhenExpandCard;
  }

  /**
   * 是否开启胶囊展开时状态栏模糊效果
   */
  public isBlurStatusBarWhenExpandCapsule(): boolean {
    if (this.isRealtimeBlur) {
      return SystemUICcmConfig.instance.liveConfig.isBlurStatusBarWhenExpandCapsule();
    }
    return this.blurStatusBarWhenExpandCapsule;
  }

  /**
   * 是否开启融球辉光
   */
  public isShowLightWhenFusionMetaball(): boolean {
    log.showError(`showLightWhenFusionMetaball ${this.isRealtimeBlur} ${this.showLightWhenFusionMetaball}`);
    if (this.isRealtimeBlur) {
      return SystemUICcmConfig.instance.liveConfig.isShowLightWhenFusionMetaball();
    }
    return this.showLightWhenFusionMetaball;
  }

  private parseSystemuiLive2(temp: SceneboardComponent): void {
    this.isRealtimeBlur = this.parseString(temp?.sceneboard?.liveview?.isRealtimeBlur);
    this.showLightWhenExpandCapsule = this.parseString(temp?.sceneboard?.liveview?.showLightWhenExpandCapsule);
    this.showLightWhenExpandCard = this.parseString(temp?.sceneboard?.liveview?.showLightWhenExpandCard);
    this.blurStatusBarWhenExpandCapsule =
      this.parseString(temp?.sceneboard?.liveview?.blurStatusBarWhenExpandCapsule);
    this.showLightWhenFusionMetaball = this.parseString(temp?.sceneboard?.liveview?.showLightWhenFusionMetaball);
  }

  private parseString(value?: string): boolean {
    return value !== 'false';
  }
}

//组件
interface SceneboardComponent extends CommonComponent {
  sceneboard: SystemUIScene;
}

//场景
interface SystemUIScene {
  liveview: LiveView;
}

//属性
interface LiveView {
  isRealtimeBlur: string;
  showLightWhenExpandCapsule: string;
  showLightWhenExpandCard: string;
  blurStatusBarWhenExpandCapsule: string;
  showLightWhenFusionMetaball: string;
}
