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
import { BannerPanelTypeState } from '../../../banner/common/info/BannerState';
import { bannerMgr } from '../../../banner/phone/BannerManager';
import { ColorUtil } from '../../../utils/ColorUtil';
import { LiveViewCapsuleStyle } from '../../common/LiveViewCapsuleStyle';
import { LiveCapsuleData } from '../../data/capsule/LiveCapsuleData';
import { LiveProgressData } from '../../data/extend/LiveProgressData';
import { CapsuleHideScene, CapsuleListState } from '../../info/capsule/CapsuleListState';
import { ProgressCapsuleWaveState } from '../../info/capsule/ProgressCapsuleWaveState';
import { ProgressCapsuleAnimMgr } from '../../ProgressCapsuleAnimMgr';
import { LengthMetrics } from '@ohos.arkui.node';

const TAG = 'ProgressCapsuleWave';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 进度类胶囊波浪组件，包括进度波浪和扫光波浪
 */
@Component
export default struct ProgressCapsuleWave {
  /**
   * 波浪动效控制
   */
  private progressCapsuleAnimMgr: ProgressCapsuleAnimMgr = new ProgressCapsuleAnimMgr();
  @ObjectLink data: LiveCapsuleData;
  @ObjectLink @Watch('onWaveDataChanged') typeData: LiveProgressData;
  @ObjectLink capsuleListState: CapsuleListState;
  @Prop @Watch('onWaveDataChanged') capsuleWidth: number = 0;
  @State waveState: ProgressCapsuleWaveState = new ProgressCapsuleWaveState();
  /**
   * banner面板类型状态
   */
  @State bannerPanelType: BannerPanelTypeState = bannerMgr.getBannerState()
    .bannerPanelType;

  build() {
    Stack({ alignContent: Alignment.Start }) {
      Image(this.getWaveImageResource())
        .height('100%')
        .width(this.waveState.getWaveWidth())
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .matchTextDirection(true)
        .margin({
          start: LengthMetrics.vp(this.waveState.processWaveMarginLeft)
        })

      Image(this.getWaveImageResource())
        .height('100%')
        .width(this.waveState.getWaveWidth())
        .objectFit(ImageFit.Contain)
        .opacity(this.waveState.moveWaveOpacity)
        .draggable(false)
        .matchTextDirection(true)
        .margin({
          start: LengthMetrics.vp(this.waveState.moveWaveMarginLeft)
        })
    }
    .draggable(false)
    .width('100%')
    .height('100%')
    .visibility(this.getWaveVisibility() ? Visibility.Visible : Visibility.None)
    .onVisibleAreaChange([0, 1], (isVisible: boolean) => {
      if (isVisible) {
        log.showDebug(`show the wave`);
        this.progressCapsuleAnimMgr.showProgressWave(this.capsuleWidth, this.typeData);
      } else {
        log.showDebug(`stop show the wave`);
        this.progressCapsuleAnimMgr.stopShowProgressWave();
      }
    })
  }

  private getWaveImageResource(): Resource {
    return ColorUtil.checkUseLightColor(this.data?.backgroundColor ??
      LiveViewCapsuleStyle.CAPSULE_DEFAULT_BG_COLOR) ?
        $r('app.media.week_wave') :
        $r('app.media.strong_wave');
  }

  private getWaveVisibility(): boolean {
    if (this.bannerPanelType?.hasPanelCapsuleList()) {
      return false;
    }
    if (this.capsuleListState.capsuleHideScene !== CapsuleHideScene.SCENE_NONE) {
      return false;
    }
    return true;
  }

  onWaveDataChanged(): void {
    this.progressCapsuleAnimMgr.refreshProgressWaveMarginLeft(this.capsuleWidth, this.typeData);
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.waveState = this.progressCapsuleAnimMgr.getWaveState();
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
  }
}

