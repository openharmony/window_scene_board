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

import { AppStorageUtil, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import {LocationController, LocationData } from '../controller/LocationController';
import { StyleConfigurationCommon, CommonStyle } from '@ohos/systemuicommon/Index';
import StyleConfiguration, { StartsBarLocationComponentStyle } from '../common/StyleConfiguration';
import { StatusBarAnimateLocationData } from '../common/Constants';
import { GlobalContext, PluginSlot } from '@ohos/frameworkwrapper';
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';
// instrument ignore file

const TAG = 'location-StatusBarIconItemLocationComponent';
const COMPONENT_ID_GPS = TAG + '_Image_gps';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const LOCATION_ICON_KEEP_STATE_TIME_MS = 3000;
const LOCATION_ICON_APPEAR_TIME_MS = 500;
const LOCATION_ICON_CHANGE_TIME_MS = 500;

@Component
export default struct StatusBarIconItemLocationComponent {
  @State mLocationData: LocationData = LocationController.getInstance().getData();
  // 监听数据变化
  @StorageProp('statusBarAnimateLocationDataKey') @Watch('refreshLocationData') mStatusBarAnimateLocationData: StatusBarAnimateLocationData | undefined = AppStorage.get<StatusBarAnimateLocationData>('statusBarAnimateLocationDataKey');
  @StorageProp('locationOldIsReOpen') locationOldIsReOpen: boolean | undefined = AppStorage.get<boolean>('locationOldIsReOpen');
  @StorageProp('locationOldIsShow') locationOldIsShow: boolean | undefined = AppStorage.get<boolean>('locationOldIsShow');
  @State style: StartsBarLocationComponentStyle = StyleConfiguration.getStartsBarLocationComponentStyle();
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  // 防抖，当前是否在执行动效阶段
  @State isCurAnimating: boolean = false;
  // 位置图标蓝底圈初始值
  @State locationBlueScale: number = 0.5;
  @State locationBlueOpacity: number = 0;
  @State locationBlueTranslateX: number = ResUtils.getNumberFromLength(this.style.statusBarLocationWidth) / 4;
  // 位置图标初始值
  @State locationScale: number = 0.75;
  @State locationOpacity: number = 0;
  // 位置镂空初始值
  @State locationEmptyScale: number = 0.4;
  @State locationEmptyOpacity: number = 0;
  /**
   * 内容颜色
   */
  @Consume contentColor: string;
  // 监听用户切换变化
  @StorageProp('privacyIndicatorUserChangeKey') @Watch('refreshPrivacyStateChange') privacyIndicatorUserChangeKey: boolean | undefined =
    AppStorage.get<boolean>('privacyIndicatorUserChangeKey');

  private uid: string = '';

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    const res = GlobalContext.getContext()?.resourceManager;
    return res.getStringByNameSync('accessibility_status_bar_location');
  }

  aboutToAppear() {
    this.uid = Date.now().toString();
    log.showInfo(`aboutToAppear, uid: ${this.uid}`);
    this.refreshLocationData();
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear, uid: ${this.uid}`);
  }

  // 位置图标出现时蓝底圈
  @Builder
  locationBlue() {
    Image($r('app.media.ic_location_blue'))
      .draggable(false)
      .id('location-StatusBarIconItemLocationComponent_Image')
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarLocationHeight)
      .height(this.style.statusBarLocationHeight)
      .scale({ x: this.locationBlueScale, y: this.locationBlueScale })
      .opacity(this.locationBlueOpacity)
      .translate({ x: this.locationBlueTranslateX })
  }

  // 位置图标
  @Builder
  locationIcon() {
    Image(this.mLocationData.showType === 2 ? $r('app.media.ic_statusbar_gps_hd') : $r('app.media.ic_statusbar_gps'))
      .draggable(false)
      .id(COMPONENT_ID_GPS)
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarLocationHeight)
      .height(this.style.statusBarLocationHeight)
      .scale({ x: this.locationScale, y: this.locationScale })
      .opacity(this.locationOpacity)
      .fillColor(this.contentColor)
  }

  // 镂空图标
  @Builder
  locationEmpty() {
    Image($r('app.media.ic_location_empty'))
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarLocationHeight)
      .height(this.style.statusBarLocationHeight)
      .scale({ x: this.locationEmptyScale, y: this.locationEmptyScale })
      .translate({ x: this.locationBlueTranslateX })
      .fillColor('#FFFFFF')
      .opacity(this.locationEmptyOpacity)
  }

  @Builder
  buildLocation() {
    if (this.isCurAnimating) {
      this.locationBlue()
      this.locationEmpty()
    }
    this.locationIcon()
  }

  build() {
    Row() {
      Stack() {
        this.buildLocation()
      }
      .width(this.style.statusBarLocationHeight)
      .height(this.style.statusBarLocationHeight)
    }
    .height('100%')
    .opacity($r('app.float.icon_component_opacity'))
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }

  /**
   * 监听位置数据变化
   */
  private refreshLocationData() {
    log.showInfo(`status: ${LocationController.getInstance().getViewData().isOn}, isShow: ${this.mStatusBarAnimateLocationData?.isShow}, isReOpen: ${this.mStatusBarAnimateLocationData?.isReOpen}`);
    log.showInfo(`oldIsShowNew: ${this.locationOldIsShow},oldIsReOpen: ${this.locationOldIsReOpen}`);
    // 开关未打开或者未调用位置,开启超级隐私模式设置动效模式避免频繁闪烁
    if (LocationController.getInstance().getStatusBarLocationIconIsVisible() !== true) {
      log.showInfo('status is closed or close location , not need process');
      AppStorageUtil.setOrCreate<boolean>('locationOldIsReOpen', this.mStatusBarAnimateLocationData?.isReOpen);
      AppStorageUtil.setOrCreate<boolean>('locationOldIsShow', this.mStatusBarAnimateLocationData?.isShow);
    }
    // 数据未发生变化，不执行动效
    if (this.mStatusBarAnimateLocationData?.isShow === this.locationOldIsShow &&
      this.mStatusBarAnimateLocationData?.isReOpen === this.locationOldIsReOpen) {
      log.showInfo('show data and reopen data not changed, not need animate');
      this.locationScale = 1;
      this.locationOpacity = 1;
      return;
    }
    AppStorageUtil.setOrCreate<boolean>('locationOldIsReOpen', this.mStatusBarAnimateLocationData?.isReOpen);
    AppStorageUtil.setOrCreate<boolean>('locationOldIsShow', this.mStatusBarAnimateLocationData?.isShow);
    this.locationScale = 0.75;
    this.locationOpacity = 0;
    this.locationEmptyScale = 0.4;
    this.locationEmptyOpacity = 0;
    this.locationBlueTranslateX = ResUtils.getNumberFromLength(this.style.statusBarLocationWidth) / 4;
    this.locationBlueScale = 0.5;
    this.locationBlueOpacity = 0;
    // 监听到开启位置信息，开始执行动效
    if (!this.isCurAnimating) {
      // 5秒内应用重新打开位置图标，直接显示图标，不展示动效
      if (this.mStatusBarAnimateLocationData?.isReOpen) {
        log.showInfo('LocationData isReOpen now');
        this.locationScale = 1;
        this.locationOpacity = 1;
        return;
      }
      log.showInfo(`location animate start`);
      this.isCurAnimating = true;
      this.locationAppear();
    }
  }

  /**
   *  位置图标出现动效
   */
  private locationAppear() {
    // stage1 蓝底圈出现
    animateTo({
      duration: LOCATION_ICON_APPEAR_TIME_MS, curve: Curve.Friction, onFinish: () => {
        log.showInfo(`stage 1 location animate end`);
        // stage2 蓝底圈变小到0.9,透明度变小到消失,水滴出现变大
        setTimeout(() => {
          animateTo({
            duration: LOCATION_ICON_CHANGE_TIME_MS,
            curve: Curve.Friction,
            onFinish: () => {
              this.isCurAnimating = false;
              log.showInfo(`location animate end`);
            }
          }, () => { // stage2
            this.locationBlueScale = 0.9;
            this.locationBlueOpacity = 0;
            this.locationEmptyOpacity = 0;
            this.locationScale = 1;
            this.locationEmptyScale = 1;
            this.locationOpacity = 1;
          });
        }, LOCATION_ICON_KEEP_STATE_TIME_MS);
      }
    }, () => { // stage1
      this.locationBlueScale = 1;
      this.locationBlueOpacity = 1;
      this.locationBlueTranslateX = 0;
      this.locationEmptyScale = 1;
      this.locationEmptyOpacity = 1;
    });
  }

  async refreshPrivacyStateChange() {
    log.showInfo(`user changed, need check location privacy`);
    await LocationController.getInstance().initLocationPrivacyState();
  }
}