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
import { VOLUME_PANEL_MAX_KEY, VOLUME_PANEL_MIN_KEY } from './VolumePanelVM';
import Constants from '../common/Constants';
import ViewModel from './VolumePanelVM';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { LogDomain, LogHelper, AnimateToScheduleUtils } from '@ohos/basicutils';
import { DeviceHelper, HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { curves } from '@kit.ArkUI';
import { RTLUtil } from '@ohos/componenthelper';


const TAG = 'VolumePanelViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const LOW_VOLUME_SEGMENT = 1 / 3;
const HIGH_VOLUME_SEGMENT = 2 / 3;
const DELAY_TIME = 50;
// 默认的最小值为0，防止UI值计算为0但实际音量不为0
const DEFAULT_MIN_VALUE = 0;

@Observed
export class VolumeDraggingViewData {
  public isDragging: boolean = false;
}

@Observed
export class VolumeViewData {
  public volumeUIValue: number = 0;
}

export class VolumePanelViewModel {
  private mPhysicsValue: number = 0;
  private maxVolume: SubscribedAbstractProperty<number>;
  private minVolume: SubscribedAbstractProperty<number>;
  private isPanelDismissing: boolean = false;
  public currentEndPositionX: number = 0;
  private lastX: number = 0;
  private lastEndPositionX: number = 0;
  private readonly VOLUME_WIDTH: number = 312
  private isPc: boolean = DeviceHelper.isPC();
  private viewData: VolumeViewData = new VolumeViewData();
  private draggingViewData: VolumeDraggingViewData = new VolumeDraggingViewData();
  private sliderValue: number = -1;
  private timer: number | null = null;

  public aboutToAppear(mPhysicsValue: number) {
    this.mPhysicsValue = mPhysicsValue;
    this.viewData.volumeUIValue = this.countUIValueByPhysicsValue(this.mPhysicsValue);
  }

  constructor() {
    this.maxVolume = AppStorage.setAndLink(VOLUME_PANEL_MAX_KEY, Constants.DEFAULT_MAX_VOLUME);
    this.minVolume = AppStorage.setAndLink(VOLUME_PANEL_MIN_KEY, Constants.DEFAULT_MIN_VOLUME);
  }

  public getViewData(): VolumeViewData {
    return this.viewData;
  }

  updatePhysicsValue(mPhysicsValue: number) {
    if (mPhysicsValue === this.countPhysicsValue(this.viewData.volumeUIValue)) {
      log.error('volume is no changed');
      return;
    }

    this.mPhysicsValue = mPhysicsValue;
    animateTo({
      curve: curves.responsiveSpringMotion(0.28, 0.97, 0)
    }, () => {
      this.viewData.volumeUIValue = this.countUIValueByPhysicsValue(this.mPhysicsValue);
    })
  }

  private countUIValueByPhysicsValue(mPhysicsValue: number): number {
    const range = this.maxVolume.get() - DEFAULT_MIN_VALUE;
    const percentage = (mPhysicsValue - DEFAULT_MIN_VALUE) / range;
    const volumeUI = this.VOLUME_WIDTH * percentage;
    log.showInfo(`set mPhysicsValue:${mPhysicsValue}; range:${range} percentage:${percentage}; countUIValue:${volumeUI}`);
    return volumeUI;
  }

  public getVolumeUIValue(): number {
    return this.viewData.volumeUIValue;
  }

  public handleOnTouch(event?: TouchEvent): void {
    if (!this.isPc) {
      if (event?.type == TouchType.Move && this.draggingViewData.isDragging === true && event?.stopPropagation) {
        event?.stopPropagation();
      }
      return;
    }
    if (event?.type === TouchType.Move) {
      return;
    }
    if (this.draggingViewData.isDragging) {
      return;
    }

    // PC音量条交互逻辑
    animateTo({
      curve: Curve.EaseInOut,
      tempo: 7
    }, () => {
      this.viewData.volumeUIValue = RTLUtil.isRTL() ? this.VOLUME_WIDTH - event!.touches[0].x : event!.touches[0].x;
    });
    let mPhysicsValue = this.countPhysicsValue(this.viewData.volumeUIValue);
    log.showInfo(`handleOnTouch: ${this.viewData.volumeUIValue};range: ${mPhysicsValue}`);
    //Down的时候更新
    if (event?.type === TouchType.Down) {
      this.updateVolume(mPhysicsValue);
      this.mPhysicsValue = mPhysicsValue
      HiDfxEventUtil.reportSlideSelectedVolBar(ViewModel.mCurrentAudioVolumeType, mPhysicsValue);
    }
  }

  public onPanActionStart(event: GestureEvent) {
    this.isPanelDismissing = DropDownPanelManager.isPanelDismissing();
    if (this.isPanelDismissing) {
      log.showWarn('panel is dismissing');
      return;
    }
    log.showInfo('touch start');
    if (!this.draggingViewData.isDragging) {
      this.draggingViewData.isDragging = true;
    }
    this.currentEndPositionX = this.viewData.volumeUIValue;
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(0);
    this.lastX = (RTLUtil.isRTL() ? this.VOLUME_WIDTH - event?.offsetX : event?.offsetX) ?? 0;
    this.lastEndPositionX = 0;
  }

  public onPanActionUpdate(event: GestureEvent) {
    if (!event) {
      return;
    }
    if (this.isPanelDismissing) {
      log.showWarn('panel is dismissing');
      return;
    }
    if (!this.draggingViewData.isDragging) {
      log.showDebug('onActionUpdate, not dragging, return');
      return;
    }

    let moveDistance = (RTLUtil.isRTL() ? this.VOLUME_WIDTH - event?.offsetX : event?.offsetX) - this.lastX;
    if (Math.abs(moveDistance - 0) < Number.EPSILON) {
      return;
    }

    this.lastX = RTLUtil.isRTL() ? this.VOLUME_WIDTH - event?.offsetX : event?.offsetX;
    let dis = event?.offsetX - this.lastEndPositionX;
    this.currentEndPositionX = RTLUtil.isRTL() ? this.currentEndPositionX - dis :
      this.currentEndPositionX + dis;
    this.lastEndPositionX = event?.offsetX;
    this.onCurrentEndPositionXChange();
  }

  public onPanActionEnd(event: GestureEvent) {
    log.showInfo('touch end ');
    if (!this.draggingViewData.isDragging) {
      log.showDebug('onActionEnd, not dragging, return');
      return;
    }
    if (this.isPanelDismissing) {
      log.showWarn('panel is dismissing');
      return;
    }

    this.draggingViewData.isDragging = false;
    let mPhysicsValue = this.countPhysicsValue(this.viewData.volumeUIValue);
    HiDfxEventUtil.reportSlideSelectedVolBar(ViewModel.mCurrentAudioVolumeType, mPhysicsValue);
    this.updateVolume(mPhysicsValue);
  }

  private onCurrentEndPositionXChange() {
    if (!this.draggingViewData.isDragging) {
      log.showDebug('onCurrentEndPositionXChange,but not dragging, return');
      return;
    }

    animateTo({
      curve: curves.responsiveSpringMotion(0.1, 1, 0)
    }, () => {
      this.viewData.volumeUIValue = Math.min(
        Math.max(this.currentEndPositionX, this.calMinUIValue()),
        this.VOLUME_WIDTH);
    })
    log.showInfo(`volumeUIValue: ${this.viewData.volumeUIValue}`);
    let mPhysicsValue = this.countPhysicsValue(this.viewData.volumeUIValue);
    this.mPhysicsValue = mPhysicsValue
    HiDfxEventUtil.reportSlideSelectedVolBar(ViewModel.mCurrentAudioVolumeType, mPhysicsValue);
    this.updateVolume(mPhysicsValue);
  }

  // QXS上部分类型的音量值不能为0，UI显示条此时不能在最左端
  private calMinUIValue(): number {
    //获取当前类型音量的最小值
    const minValue = this.minVolume.get();
    // 计算当前音量对应的UI值
    const minUIValue = this.countUIValueByPhysicsValue(minValue);
    log.showInfo(`minValue: ${minValue}, minUIValue: ${minUIValue}`);
    return minUIValue;
  }

  private getVolumeRange(): number {
    return this.maxVolume.get() - DEFAULT_MIN_VALUE;
  }

  private countPhysicsValue(uiVar: number): number {
    let range = this.getVolumeRange();
    if (this.VOLUME_WIDTH <= 0 || range <= 0) {
      return 0;
    }
    let volume = uiVar / this.VOLUME_WIDTH * range + DEFAULT_MIN_VALUE;
    // 解决取整问题：静音但仍显示有音量，音量已达最大值，控制中心显示音量未达最大值
    if (volume < range * LOW_VOLUME_SEGMENT) {
      volume = Math.ceil(volume);
    } else if (volume > range * HIGH_VOLUME_SEGMENT) {
      volume = Math.floor(volume);
    } else {
      volume = Math.round(volume);
    }
    if (volume > this.maxVolume.get()) {
      volume = this.maxVolume.get();
    } else if (volume < this.minVolume.get()) {
      volume = this.minVolume.get();
    }
    log.showInfo(`countPhysicsValue to ui value: ${volume}; uiVar: ${uiVar}`);
    return Math.round(volume);
  }

  public getAccessibilityVolumeValue(volume: number): string {
    if (this.getVolumeRange() <= 0) {
      return volume.toFixed(0);
    }
    return ((volume - DEFAULT_MIN_VALUE) / this.getVolumeRange() * 100).toFixed(0);
  }

  public updateVolume(volume: number): void {
    const currentAudioVolumeType = ViewModel.mCurrentAudioVolumeType;
    log.showInfo(`currentAudioVolumeType: ${currentAudioVolumeType}`);
    this.sliderValue = volume;
    if (!this.timer) {
      this.timer = setTimeout(() => {
        HiDfxEventUtil.reportSlideSelectedVolBar(currentAudioVolumeType, this.sliderValue); // 打点
        ViewModel.setVolumeByType(currentAudioVolumeType, this.sliderValue);
        clearTimeout(this.timer);
        this.timer = null;
      }, DELAY_TIME);
    }
  }
}

let volumePanelViewModel = new VolumePanelViewModel();

export default volumePanelViewModel as VolumePanelViewModel;