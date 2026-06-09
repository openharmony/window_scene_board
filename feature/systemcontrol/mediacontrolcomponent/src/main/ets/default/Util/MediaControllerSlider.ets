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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { BannerPanelType } from '@ohos/systemuicommon/src/main/ets/banner/common/info/BannerState';
import { TargetPanel } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import Constants from './Constants';
import { ResUtils } from '@ohos/windowscene';

const TAG: string = 'MediaControllerSlider';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const REFRESH_TIME: number = 100;

@Component
export struct MediaControllerSlider {
  @Link @Watch('doPositionProcess') private movePositionPreferSet: number;
  @Link private sliderMax: number;
  @State private sliderMin: number = 0;
  @State private sliderStep: number = 1;
  @State private sliderStyle: SliderStyle = SliderStyle.InSet;
  @State private sliderDirection: Axis = Axis.Horizontal;
  @State private sliderPadding: Padding =
    {
      left: 0,
      right: 0
    };
  @Link private sliderTrackThickness: Length;
  @Prop private sliderSelectedColor: ResourceColor = '#FFFFFFFF';
  @Prop private sliderTrackColor: ResourceColor | LinearGradient | undefined = undefined;
  @Prop private sliderBlockColor: ResourceColor = '#FFFFFFFF';
  @Prop private sliderIsActive: boolean = true;
  @State private sliderWidth: Length = '100%';
  @State private sliderFlexShrink: number = 1;
  @State private sliderShowSteps: boolean = false;
  @State private sliderShowTips: boolean = false;
  @State private sliderShowTipsContent: ResourceStr = '';
  @State private sliderBlockBorderWidth: Length = 0;
  @State private sliderEnabled: boolean = true;
  @State private sliderBlockStyle: SliderBlockStyle =
    {
      type: SliderBlockType.SHAPE,
      shape: new Path({ commands: 'M60 60 M30 30 L15 56 L45 56 Z' })
    };
  private sliderChangeCallback: Function =
    (value: number, mode: SliderChangeMode): void => {};
  @State private sliderKey: string = '';
  @State private slideAccessDescription: string = '';
  @State private moveStartCachePosition: number[] = [];
  @State private movePositionStartCache: number = 0;
  @Link @Watch('truePositionUpdate') private movePositionTrueSet: number;
  @State private positionChangeCount: number = 0;
  @State private shortTimeWait: number = 500;
  @State private longTimeWait: number = 2000;
  @State private shortTimestamp: number = -1;
  @State private longTimestamp: number = -1;
  @State private timeRefreshId: number = -1;
  @State private timeRefreshInterval: number = 1000;
  @Link private shortTimeUpdateCount: number;
  @Link private callSeekCount: number;
  @State private showSlider: boolean = true;
  @Prop @Watch('bannerPanelChanged') bannerPanelType: BannerPanelType | undefined = undefined;
  @StorageLink('systemLanguage') systemLanguage: string = Constants.DEFAULT_LANGUAGE;
  @Prop sceneType: string | undefined = undefined;
  @StorageLink('mediaPanelState') @Watch('onMediaPanelStateChanged') mediaPanelState: TargetPanel = TargetPanel.NONE;

  aboutToAppear(): void {
    this.movePositionTrueSet = this.movePositionPreferSet;
    this.doTimeRefreshSet();
    log.showInfo(`MediaControllerSlider on aboutToAppear ${this.timeRefreshId}`);
  }

  aboutToDisappear(): void {
    log.showInfo(`MediaControllerSlider on aboutToDisappear dis clear  ${this.timeRefreshId}`);
    clearInterval(this.timeRefreshId);
    this.doEndRefresh();
  }

  doTimeRefreshSet() {
    log.showInfo(`MediaControllerSlider on doTimeRefreshSet with id befcheck ${this.timeRefreshId}`);
    if (this.timeRefreshId >= 0) {
      clearInterval(this.timeRefreshId);
      this.timeRefreshId = -1;
    }
    this.timeRefreshId = setInterval(() => {
      let curTime: number = new Date().getTime();
      log.showDebug(`MediaControllerSlider on doTimeRefreshSet ${curTime} ${this.shortTimestamp} ${this.longTimestamp} id ${this.timeRefreshId}`);
      if (this.shortTimestamp > 0 && (curTime - this.shortTimestamp >= this.shortTimeWait)) {
        log.showInfo(`MediaControllerSlider on doTimeRefreshSet checkin short time  ${curTime} ${this.shortTimestamp}`);
        this.doShortTimeWaitSet();
      }
      if (this.longTimestamp > 0 && (curTime - this.longTimestamp >= this.longTimeWait)) {
        log.showInfo(`MediaControllerSlider on doTimeRefreshSet checkin long time  ${curTime} ${this.longTimestamp}`);
        this.doLongTimeWaitSet();
      }
    }, this.timeRefreshInterval);
    log.showInfo(`MediaControllerSlider on doTimeRefreshSet with id ${this.timeRefreshId}`);
  }

  doPositionProcess() {
    if (this.moveStartCachePosition.length <= 0) {
      this.doPositionSet(this.movePositionPreferSet);
      return;
    } else {
      let checkPositionAvailableCount: number = 0;
      this.moveStartCachePosition.forEach((singCache) => {
        if (Math.abs(this.movePositionTrueSet - this.movePositionPreferSet) <=
          Math.abs(singCache - this.movePositionPreferSet)) {
          log.showInfo(`MediaControllerSlider on doPositionProcess check ${singCache}`);
          checkPositionAvailableCount++;
        } else {
          log.showInfo(`MediaControllerSlider on doPositionProcess check fail  ${singCache}`);
        }
      });
      if (checkPositionAvailableCount >= this.moveStartCachePosition.length) {
        log.showInfo(`MediaControllerSlider on doPositionProcess suc with ${this.movePositionPreferSet} ${this.moveStartCachePosition.length}`);
        this.doEndRefresh();
      }
    }
  }

  doShortTimeWaitSet() {
    if (this.moveStartCachePosition.length <= 0 || this.shortTimeUpdateCount > 5 * this.callSeekCount ||
      this.shortTimeUpdateCount == 0) {
      log.showInfo(`MediaControllerSlider on doShortTimeWaitSet checkin noNeed refresh ${this.moveStartCachePosition.length}
        MediaControllerSlider on doShortTimeWaitSet checkin noNeed refresh ${this.shortTimeUpdateCount} ${this.callSeekCount}`);
      return;
    }
    if (Math.abs(this.movePositionStartCache - this.movePositionPreferSet) <=
      Math.abs(this.movePositionTrueSet - this.movePositionPreferSet)) {
      log.showInfo(`MediaControllerSlider on doShortTimeWaitSet checkin refresh ${this.movePositionStartCache}
        MediaControllerSlider on doShortTimeWaitSet checkin refresh ${this.movePositionPreferSet} ${this.movePositionTrueSet}`);
      this.doEndRefresh();
    } else {
      log.showInfo(`MediaControllerSlider on doShortTimeWaitSet checkin  not meet refresh ${this.movePositionStartCache}
        MediaControllerSlider on doShortTimeWaitSet checkin refresh ${this.movePositionPreferSet} ${this.movePositionTrueSet}`);
    }
  }

  doLongTimeWaitSet() {
    if (this.moveStartCachePosition.length <= 0) {
      log.showInfo(`MediaControllerSlider on doLongTimeWaitSet checkin noNeed refresh ${this.moveStartCachePosition.length}`);
      return;
    } else {
      log.showInfo(`MediaControllerSlider on doLongTimeWaitSet checkin refresh ${this.movePositionStartCache}
        MediaControllerSlider on doLongTimeWaitSet checkin refresh ${this.movePositionPreferSet} ${this.movePositionTrueSet}`);
      this.doEndRefresh();
    }
  }

  doEndRefresh() {
    log.showInfo(`MediaControllerSlider on doEndRefresh in ${this.moveStartCachePosition.length}`);
    this.moveStartCachePosition.splice(0, this.moveStartCachePosition.length);
    this.movePositionStartCache = -1;
    this.shortTimestamp = -1;
    this.longTimestamp = -1;
    this.doPositionSet(this.movePositionPreferSet);
    log.showInfo(`MediaControllerSlider on doEndRefresh clear ${this.moveStartCachePosition.length} ${this.positionChangeCount}`);
  }

  doPositionSet(positon: number) {
    this.movePositionTrueSet = positon;
    this.callSeekCount = 0;
    this.shortTimeUpdateCount = 0;
  }

  refreshSlider() {
    this.showSlider = false;
    setTimeout(() => {
      this.showSlider = true;
    }, REFRESH_TIME);
  }

  bannerPanelChanged() {
    log.showInfo(`bannerPanelChanged ${this.bannerPanelType}`);
    if (this.bannerPanelType === BannerPanelType.TYPE_LIVE_LIST) {
      this.refreshSlider();
    }
  }

  onMediaPanelStateChanged() {
    if (this.mediaPanelState === TargetPanel.NOTIFICATION_PANEL && this.sceneType === 'notify') {
      log.showInfo(`refresh slider`);
      this.refreshSlider();
    }
  }

  truePositionUpdate() {
    let curtime = Math.floor(this.movePositionTrueSet / 1000);
    let durationHours = Math.floor(this.sliderMax / 1000 / 3600);
    let hours = Math.floor(curtime / 3600);
    let durationMinutes = Math.floor((this.sliderMax / 1000 / 60) % 60).toString().padStart(2, '0');
    let minutes = Math.floor((curtime / 60) % 60).toString().padStart(2, '0');
    let durationSeconds = (this.sliderMax / 1000 % 60).toFixed(0).padStart(2, '0');
    let seconds = (curtime % 60).toString().padStart(2, '0');
    let startMinuteText = `${minutes}:${seconds}`;
    let durationText = `${durationMinutes}:${durationSeconds}`;
    if (durationHours > 0) {
      startMinuteText = `${hours.toString().padStart(2, '0')}:${startMinuteText}`;
      durationText = `${durationHours.toString().padStart(2, '0')}:${durationText}`;
    } else if (this.systemLanguage.indexOf('zh') >= 0) {
      startMinuteText = `${minutes}${Constants.MINUTE_CN}${seconds}${Constants.SECOND_CN}`;
      durationText = `${durationMinutes}${Constants.MINUTE_CN}${durationSeconds}${Constants.SECOND_CN}`;
    }
    this.slideAccessDescription =
      `${ResUtils.getInnerString($r('app.string.access_playback_progress'))}${startMinuteText}
      ${ResUtils.getInnerString($r('app.string.access_total_duration'))}${durationText}`;
  }

  build() {
    Column() {
      if (this.showSlider) {
        Slider({
          value: this.movePositionTrueSet > this.sliderMax ? this.sliderMax : this.movePositionTrueSet,
          min: this.sliderMin,
          max: this.sliderMax,
          step: this.sliderStep,
          style: this.sliderStyle,
          direction: this.sliderDirection,
        })
          .padding(this.sliderPadding)
          .trackThickness(this.sliderTrackThickness)
          .selectedColor(this.sliderSelectedColor)
          .trackColor(this.sliderTrackColor)
          .blockColor(this.sliderBlockColor)
          .width(this.sliderWidth)
          .flexShrink(this.sliderFlexShrink)
          .showSteps(this.sliderShowSteps)
          .showTips(this.sliderShowTips, this.sliderShowTipsContent)
          .blockBorderWidth(this.sliderBlockBorderWidth)
          .enabled(this.sliderIsActive)
          .blockStyle(this.sliderBlockStyle)
          .onTouch((event: TouchEvent) => {
            event?.stopPropagation();
          })
          .onChange((value: number, mode: SliderChangeMode) => {
            log.showInfo(`on change touch ${value}/${this.sliderMax} ${mode}`);
            if (value > this.sliderMax) {
              return;
            }
            if (mode !== SliderChangeMode.Moving) {
              log.showInfo(`on change push ${this.movePositionTrueSet} and change to new ${value}`);
              if (mode === SliderChangeMode.End || mode === SliderChangeMode.Click) {
                this.movePositionStartCache = this.movePositionTrueSet;
                this.shortTimestamp = this.longTimestamp = new Date().getTime();
                log.showInfo(`on change push start cache set ${this.movePositionTrueSet} ${this.shortTimestamp}`);
              }
              this.moveStartCachePosition.push(this.movePositionTrueSet);
              this.movePositionTrueSet = value;
            } else {
              this.movePositionTrueSet = value;
            }
            this.sliderChangeCallback(value, mode);
          })
          .key(this.sliderKey)
          .hitTestBehavior(HitTestMode.Block)
          .accessibilityText(this.sliderEnabled ? this.slideAccessDescription : undefined)
      } else {
        Slider({
          value: this.movePositionTrueSet > this.sliderMax ? this.sliderMax : this.movePositionTrueSet,
          min: this.sliderMin,
          max: this.sliderMax,
          step: this.sliderStep,
          style: this.sliderStyle,
          direction: this.sliderDirection,
        })
          .padding(this.sliderPadding)
          .trackThickness(this.sliderTrackThickness)
          .selectedColor(this.sliderSelectedColor)
          .trackColor(this.sliderTrackColor)
          .blockColor(this.sliderBlockColor)
          .width(this.sliderWidth)
          .flexShrink(this.sliderFlexShrink)
          .showSteps(this.sliderShowSteps)
          .showTips(this.sliderShowTips, this.sliderShowTipsContent)
          .blockBorderWidth(this.sliderBlockBorderWidth)
          .enabled(this.sliderIsActive)
          .blockStyle(this.sliderBlockStyle)
          .key(this.sliderKey)
          .hitTestBehavior(HitTestMode.Block)
          .onTouch((event: TouchEvent) => {
            event?.stopPropagation();
          })
      }
    }
    .width(this.sliderWidth)
    .onAreaChange((oldValue: Area, newValue: Area) => {
      if (oldValue.width !== newValue.width) {
        this.refreshSlider();
      }
    })
  }
}