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

import { LogDomain, Logger } from '@ohos/basicutils';
import Constants, { WifiData } from '../common/Constants';
import { WifiController } from '../controller/WifiController';
import StyleConfiguration from '../common/StyleConfiguration';
import { StartsBarWifiComponentStyle } from '../common/StyleConfiguration';
import { ImageIconModifier } from '@ohos/systemuicommon/Index';
import { GlobalContext, PluginSlot } from '@ohos/frameworkwrapper';
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';
// instrument ignore file

const TAG = 'WifiComponent-WifiIcon';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

const COMPONENT_ID_WIFI_SIGNAL_LEVEL = TAG + '_Image_wifi_signal_level';
const COMPONENT_ID_WIFI_DATA_FLOW = TAG + '_Image_wifi_data_flow';

class IconConfig {
  public isAlwaysShown: boolean = false
}

@Component
export default struct WifiIcon {
  private mIconConfig: IconConfig = {
    isAlwaysShown: false
  };
  @StorageProp('WifiModel_WifiStatus') mWifiData: WifiData = WifiController.getInstance().getData();
  private style: StartsBarWifiComponentStyle = StyleConfiguration.getStartsBarWifiComponentStyle();
  /**
   * 内容颜色
   */
  @Consume @Watch('onContentColorChange') contentColor: string;

  private signalLevelIconModifier: ImageIconModifier = new ImageIconModifier(COMPONENT_ID_WIFI_SIGNAL_LEVEL);

  private dataFlowIconModifier: ImageIconModifier = new ImageIconModifier(COMPONENT_ID_WIFI_DATA_FLOW);

  private wifi7ImageMap: Map<number, Resource> = new Map([
    [Constants.WIFI_SIGNAL_NO, $r('app.media.ic_statusbar_wifi7_0')],
    [Constants.WIFI_SIGNAL_LOW, $r('app.media.ic_statusbar_wifi7_1')],
    [Constants.WIFI_SIGNAL_MID, $r('app.media.ic_statusbar_wifi7_2')],
    [Constants.WIFI_SIGNAL_HIGH, $r('app.media.ic_statusbar_wifi7_3')],
    [Constants.WIFI_SIGNAL_FULL, $r('app.media.ic_statusbar_wifi7_4')]
  ]);

  private wifi7PlusImageMap: Map<number, Resource> = new Map([
    [Constants.WIFI_SIGNAL_NO, $r('app.media.ic_statusbar_wifi7plus_0')],
    [Constants.WIFI_SIGNAL_LOW, $r('app.media.ic_statusbar_wifi7plus_1')],
    [Constants.WIFI_SIGNAL_MID, $r('app.media.ic_statusbar_wifi7plus_2')],
    [Constants.WIFI_SIGNAL_HIGH, $r('app.media.ic_statusbar_wifi7plus_3')],
    [Constants.WIFI_SIGNAL_FULL, $r('app.media.ic_statusbar_wifi7plus_4')]
  ]);

  onContentColorChange() {
    log.info(TAG, `onContentColorChange ${this.contentColor}`);
    this.signalLevelIconModifier.modifyContentColor(this.contentColor);
    this.dataFlowIconModifier.modifyContentColor(this.contentColor);
  }

  aboutToAppear() {
    this.signalLevelIconModifier.initContentColor(this.contentColor);
    this.dataFlowIconModifier.initContentColor(this.contentColor);
    log.showDebug(TAG, `aboutToAppear, mIconConfig: ${this.mIconConfig?.isAlwaysShown}`);
  }

  aboutToDisappear() {
    log.showDebug(TAG, 'aboutToDisappear');
  }

  build() {
    Stack() {
      Image(this.mWifiData.isMetered ? this.getHotspotImage(this.mWifiData.signalLevel) :
      this.getImage(this.mWifiData.signalLevel, this.mWifiData.supportedWifiCategory))
        .attributeModifier(this.signalLevelIconModifier)
        .draggable(false)
        .id(COMPONENT_ID_WIFI_SIGNAL_LEVEL)
        .objectFit(ImageFit.Contain)
        .width(this.style.statusBarWifiWidth)
        .height(this.style.statusBarWifiHeight)
        .opacity($r('app.float.icon_component_opacity'))
        .onError((error) => {
          log.showWarn(TAG, `wifi image load error, ${this.mWifiData.signalLevel}, ${this.mWifiData.supportedWifiCategory}, error: ${error?.message}`);
        })

      Image(this.mWifiData.isNetworkAvailable ? this.getFlowTypeImage(this.mWifiData.dataFlowType) :
      $r('app.media.ic_statusbar_no_net'))
        .attributeModifier(this.dataFlowIconModifier)
        .draggable(false)
        .id(COMPONENT_ID_WIFI_DATA_FLOW)
        .objectFit(ImageFit.Contain)
        .width(this.style.statusBarWifiWidth)
        .height(this.style.statusBarWifiHeight)
        .opacity($r('app.float.icon_component_opacity'))
        .onError((error) => {
          log.showWarn(TAG, `wifi flow error, ${this.mWifiData.isNetworkAvailable}, ${this.mWifiData.dataFlowType}, error: ${error?.message}`);
        })
    }
    .height('100%')
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    const res = GlobalContext.getContext()?.resourceManager;
    switch (this.mWifiData.signalLevel) {
      case Constants.WIFI_SIGNAL_NO:
        return res.getStringByNameSync('accessibility_status_bar_wifi_no');
      case Constants.WIFI_SIGNAL_LOW:
        return res.getStringByNameSync('accessibility_status_bar_wifi_1');
      case Constants.WIFI_SIGNAL_MID:
        return res.getStringByNameSync('accessibility_status_bar_wifi_2');
      case Constants.WIFI_SIGNAL_HIGH:
        return res.getStringByNameSync('accessibility_status_bar_wifi_3');
      default:
        return res.getStringByNameSync('accessibility_status_bar_wifi_4');
    }
  }

  private getHotspotImage(signalLevel: number): Resource {
    let hotspotImage: Resource;
    switch (signalLevel) {
      case Constants.WIFI_SIGNAL_NO:
        hotspotImage = $r('app.media.ic_statusbar_wifi_hotspot0');
        break;
      case Constants.WIFI_SIGNAL_LOW:
        hotspotImage = $r('app.media.ic_statusbar_wifi_hotspot1')
        break;
      case Constants.WIFI_SIGNAL_MID:
        hotspotImage = $r('app.media.ic_statusbar_wifi_hotspot2')
        break;
      case Constants.WIFI_SIGNAL_HIGH:
        hotspotImage = $r('app.media.ic_statusbar_wifi_hotspot3')
        break;
      case Constants.WIFI_SIGNAL_FULL:
        hotspotImage = $r('app.media.ic_statusbar_wifi_hotspot4')
        break;
      default:
        hotspotImage = $r('app.media.ic_statusbar_wifi_hotspot4')
        break;
    }
    return hotspotImage;
  }

  private getImage(signalLevel: number, supportedWifiCategory: number): Resource {
    if (this.mWifiData.isScreenOff) {
      log.showInfo(TAG, `Is screen off show 4 level wifi icon!`);
      return this.getWifiImageScreenOff(supportedWifiCategory);
    }
    let wifiImage: Resource;
    switch (supportedWifiCategory) {
      case Constants.CATEGORY_DEFAULT:
        wifiImage = this.getDefaultImage(signalLevel);
        break;
      case Constants.CATEGORY_WIFI6:
        wifiImage = this.getWifi6Image(signalLevel);
        break;
      case Constants.CATEGORY_WIFI6_PLUS:
        wifiImage = this.getWifi6PlusImage(signalLevel);
        break;
      case Constants.CATEGORY_WIFI7:
        wifiImage = this.getWifi7Image(signalLevel);
        break;
      case Constants.CATEGORY_WIFI7_PLUS:
        wifiImage = this.getWifi7PlusImage(signalLevel);
        break;
      default:
        wifiImage = this.getDefaultImage(signalLevel);
        break;
    }
    return wifiImage;
  }

  private getWifiImageScreenOff(supportedWifiCategory: number): Resource {
    let wifiImageScreenOff: Resource;
    switch (supportedWifiCategory) {
      case Constants.CATEGORY_DEFAULT:
        wifiImageScreenOff = $r('app.media.ic_statusbar_wifi_4');
        break;
      case Constants.CATEGORY_WIFI6:
        wifiImageScreenOff = $r('app.media.ic_statusbar_wifi6_4');
        break;
      case Constants.CATEGORY_WIFI6_PLUS:
        wifiImageScreenOff = $r('app.media.ic_statusbar_wifi6plus_4');
        break;
      case Constants.CATEGORY_WIFI7:
        wifiImageScreenOff = $r('app.media.ic_statusbar_wifi7_4');
        break;
      case Constants.CATEGORY_WIFI7_PLUS:
        wifiImageScreenOff = $r('app.media.ic_statusbar_wifi7plus_4');
        break;
      default:
        wifiImageScreenOff = $r('app.media.ic_statusbar_wifi_4');
        break;
    }
    return wifiImageScreenOff;
  }

  private getDefaultImage(signalLevel: number): Resource {
    let defaultImage: Resource;
    switch (signalLevel) {
      case Constants.WIFI_SIGNAL_NO:
        defaultImage = $r('app.media.ic_statusbar_wifi_no');
        break;
      case Constants.WIFI_SIGNAL_LOW:
        defaultImage = $r('app.media.ic_statusbar_wifi_1');
        break;
      case Constants.WIFI_SIGNAL_MID:
        defaultImage = $r('app.media.ic_statusbar_wifi_2');
        break;
      case Constants.WIFI_SIGNAL_HIGH:
        defaultImage = $r('app.media.ic_statusbar_wifi_3');
        break;
      case Constants.WIFI_SIGNAL_FULL:
        defaultImage = $r('app.media.ic_statusbar_wifi_4');
        break;
      default:
        defaultImage = $r('app.media.ic_statusbar_wifi_4');
        break;
    }
    return defaultImage;
  }

  private getWifi6Image(signalLevel: number): Resource {
    let wifi6Image: Resource;
    switch (signalLevel) {
      case Constants.WIFI_SIGNAL_NO:
        wifi6Image = $r('app.media.ic_statusbar_wifi6_0');
        break;
      case Constants.WIFI_SIGNAL_LOW:
        wifi6Image = $r('app.media.ic_statusbar_wifi6_1');
        break;
      case Constants.WIFI_SIGNAL_MID:
        wifi6Image = $r('app.media.ic_statusbar_wifi6_2');
        break;
      case Constants.WIFI_SIGNAL_HIGH:
        wifi6Image = $r('app.media.ic_statusbar_wifi6_3');
        break;
      case Constants.WIFI_SIGNAL_FULL:
        wifi6Image = $r('app.media.ic_statusbar_wifi6_4');
        break;
      default:
        wifi6Image = $r('app.media.ic_statusbar_wifi6_4');
        break;
    }
    return wifi6Image;
  }

  private getWifi6PlusImage(signalLevel: number): Resource {
    let wifi6PLusImage: Resource;
    switch (signalLevel) {
      case Constants.WIFI_SIGNAL_NO:
        wifi6PLusImage = $r('app.media.ic_statusbar_wifi6plus_0');
        break;
      case Constants.WIFI_SIGNAL_LOW:
        wifi6PLusImage = $r('app.media.ic_statusbar_wifi6plus_1');
        break;
      case Constants.WIFI_SIGNAL_MID:
        wifi6PLusImage = $r('app.media.ic_statusbar_wifi6plus_2');
        break;
      case Constants.WIFI_SIGNAL_HIGH:
        wifi6PLusImage = $r('app.media.ic_statusbar_wifi6plus_3');
        break;
      case Constants.WIFI_SIGNAL_FULL:
        wifi6PLusImage = $r('app.media.ic_statusbar_wifi6plus_4');
        break;
      default:
        wifi6PLusImage = $r('app.media.ic_statusbar_wifi6plus_4');
        break;
    }
    return wifi6PLusImage;
  }

  private getWifiDoubleImage(signalLevel: number): Resource {
    let wifiDoubleImage: Resource;
    switch (signalLevel) {
      case Constants.WIFI_SIGNAL_NO:
        wifiDoubleImage = $r('app.media.ic_statusbar_wifi_double0');
        break;
      case Constants.WIFI_SIGNAL_LOW:
        wifiDoubleImage = $r('app.media.ic_statusbar_wifi_double1');
        break;
      case Constants.WIFI_SIGNAL_MID:
        wifiDoubleImage = $r('app.media.ic_statusbar_wifi_double2');
        break;
      case Constants.WIFI_SIGNAL_HIGH:
        wifiDoubleImage = $r('app.media.ic_statusbar_wifi_double3');
        break;
      case Constants.WIFI_SIGNAL_FULL:
        wifiDoubleImage = $r('app.media.ic_statusbar_wifi_double4');
        break;
      default:
        wifiDoubleImage = $r('app.media.ic_statusbar_wifi_double4');
        break;
    }
    return wifiDoubleImage;
  }

  private getDoubleWifi6image(signalLevel: number): Resource {
    let doubleWifi6Image: Resource;
    switch (signalLevel) {
      case Constants.WIFI_SIGNAL_NO:
        doubleWifi6Image = $r('app.media.ic_statusbar_wifi6_double0');
        break;
      case Constants.WIFI_SIGNAL_LOW:
        doubleWifi6Image = $r('app.media.ic_statusbar_wifi6_double1');
        break;
      case Constants.WIFI_SIGNAL_MID:
        doubleWifi6Image = $r('app.media.ic_statusbar_wifi6_double2');
        break;
      case Constants.WIFI_SIGNAL_HIGH:
        doubleWifi6Image = $r('app.media.ic_statusbar_wifi6_double3');
        break;
      case Constants.WIFI_SIGNAL_FULL:
        doubleWifi6Image = $r('app.media.ic_statusbar_wifi6_double4');
        break;
      default:
        doubleWifi6Image = $r('app.media.ic_statusbar_wifi6_double4');
        break;
    }
    return doubleWifi6Image;
  }

  private getDoubleWifi6PlusImage(signalLevel: number): Resource {
    let doubleWifi6PlusImage: Resource;
    switch (signalLevel) {
      case Constants.WIFI_SIGNAL_NO:
        doubleWifi6PlusImage = $r('app.media.ic_statusbar_wifi6plus_double_0');
        break;
      case Constants.WIFI_SIGNAL_LOW:
        doubleWifi6PlusImage = $r('app.media.ic_statusbar_wifi6plus_double_1');
        break;
      case Constants.WIFI_SIGNAL_MID:
        doubleWifi6PlusImage = $r('app.media.ic_statusbar_wifi6plus_double_2');
        break;
      case Constants.WIFI_SIGNAL_HIGH:
        doubleWifi6PlusImage = $r('app.media.ic_statusbar_wifi6plus_double_3');
        break;
      case Constants.WIFI_SIGNAL_FULL:
        doubleWifi6PlusImage = $r('app.media.ic_statusbar_wifi6plus_double_4');
        break;
      default:
        doubleWifi6PlusImage = $r('app.media.ic_statusbar_wifi6plus_double_4');
        break;
    }
    return doubleWifi6PlusImage;
  }

  private getWifi7Image(signalLevel: number): Resource {
    let wifi7Image: Resource = this.wifi7ImageMap.get(Constants.WIFI_SIGNAL_FULL)!;
    if (this.wifi7ImageMap.has(signalLevel)) {
      wifi7Image = this.wifi7ImageMap.get(signalLevel)!;
    }
    return wifi7Image;
  }

  private getWifi7PlusImage(signalLevel: number): Resource {
    let wifi7PlusImage: Resource = this.wifi7PlusImageMap.get(Constants.WIFI_SIGNAL_FULL)!;
    if (this.wifi7PlusImageMap.has(signalLevel)) {
      wifi7PlusImage = this.wifi7PlusImageMap.get(signalLevel)!;
    }
    return wifi7PlusImage;
  }

  private getFlowTypeImage(dataFlowType: number): Resource {
    if (this.mWifiData.isScreenOff) {
      return $r('app.media.ic_statusbar_wifi_up_down_0');
    }
    let flowTypeImage: Resource;
    switch (dataFlowType) {
      case Constants.DATA_FLOW_TYPE_NONE:
        flowTypeImage = $r('app.media.ic_statusbar_wifi_up_down_0');
        break;
      case Constants.DATA_FLOW_TYPE_DOWN:
        flowTypeImage = $r('app.media.ic_statusbar_wifi_down');
        break;
      case Constants.DATA_FLOW_TYPE_UP:
        flowTypeImage = $r('app.media.ic_statusbar_wifi_up');
        break;
      case Constants.DATA_FLOW_TYPE_UP_DOWN:
        flowTypeImage = $r('app.media.ic_statusbar_wifi_up_down');
        break;
      default:
        flowTypeImage = $r('app.media.ic_statusbar_wifi_up_down_0');
        break;
    }
    return flowTypeImage;
  }
}
