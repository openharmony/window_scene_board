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

import { PluginSlot } from '@ohos/frameworkwrapper';
import constants from '@ohos/wificomponent/src/main/ets/default/common/Constants';
import { WifiDetailState } from '@ohos/wificomponent/src/main/ets/default/common/Constants';
import { WifiDataPC } from '@ohos/wificomponent/src/main/ets/default/utils/WifiUtils';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'StatusBarResourceUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export default class StatusBarResUtils {
  public static getIcon = (slot: string) => {
    log.showDebug(`getIcon is ${JSON.stringify(slot)}`);
    switch (slot) {
      case PluginSlot.SLOT_STATUS_WIFI_PANEL:
        return this.getWifiIcon;
      case PluginSlot.SLOT_STATUS_CAPSULE_SCREENSHOT:
        return this.getScreenShotIcon;
      case PluginSlot.SLOT_STATUS_SMART_SCREENSHOT:
        return this.getSmartScreenShotIcon;
      case PluginSlot.SLOT_STATUS_QUICK_NOTE:
        return this.getNoteIcon;
      case PluginSlot.SLOT_STATUS_VIRTUAL_KEYBOARD:
        return this.getVirtualKeyboardIcon;
      case PluginSlot.SLOT_STATUS_SCREEN_RECORDER:
        return this.getScreenRecorderIcon;
      default:
        return undefined;
    }
  }

  // 资源文件放在pc目录下，然后想办法传到feature层。
  // 获取WiFi的静态图片
  public static getWifiIcon = (wifiDataPc: WifiDataPC, isWhite: boolean) => {
    if (wifiDataPc.isEthernetAvailable) {
      return this.getEthernetImage(isWhite);
    }
    if (wifiDataPc.isMetered) {
      return this.getHotspotImage(wifiDataPc.signalLevel, isWhite);
    } else {
      return this.getImage(wifiDataPc.state, wifiDataPc.signalLevel, wifiDataPc.supportedWifiCategory, isWhite);
    }
  }

  public static getActiveWifiIcon = (wifiDataPc: WifiDataPC, isWhite: boolean) => {
    if (!wifiDataPc.isNetworkAvailable) {
      return this.getNoNetImage(wifiDataPc.supportedWifiCategory, isWhite);
    } else {
      return this.getFlowTypeImage(wifiDataPc.dataFlowType, wifiDataPc.supportedWifiCategory, wifiDataPc.isMetered,
        isWhite);
    }
  }


  static getHotspotImage(signalLevel: number, isWhite: boolean): Resource {
    let hotspotImage: Resource;
    switch (signalLevel) {
      case constants.WIFI_SIGNAL_NO:
        hotspotImage = (isWhite ? $r('app.media.ic_statusbar_wifi_hotspot_0') :
        $r('app.media.ic_statusbar_wifi_hotspot_0_black'));
        break;
      case constants.WIFI_SIGNAL_LOW:
        hotspotImage = (isWhite ? $r('app.media.ic_statusbar_wifi_hotspot_1') :
        $r('app.media.ic_statusbar_wifi_hotspot_1_black'))
        break;
      case constants.WIFI_SIGNAL_MID:
        hotspotImage = (isWhite ? $r('app.media.ic_statusbar_wifi_hotspot_2') :
        $r('app.media.ic_statusbar_wifi_hotspot_2_black'));
        break;
      case constants.WIFI_SIGNAL_HIGH:
        hotspotImage = (isWhite ? $r('app.media.ic_statusbar_wifi_hotspot_3') :
        $r('app.media.ic_statusbar_wifi_hotspot_3_black'));
        break;
      case constants.WIFI_SIGNAL_FULL:
        hotspotImage = (isWhite ? $r('app.media.ic_statusbar_wifi_hotspot_4') :
        $r('app.media.ic_statusbar_wifi_hotspot_4_black'));
        break;
      default:
        hotspotImage = (isWhite ? $r('app.media.ic_statusbar_wifi_hotspot_4') :
        $r('app.media.ic_statusbar_wifi_hotspot_4_black'));
        break;
    }
    return hotspotImage;
  }

  static getImage(isActive: WifiDetailState, signalLevel: number, supportedWifiCategory: number,
    isWhite: boolean): Resource {
    let wifiImage: Resource;
    if (isActive !== WifiDetailState.STATE_ACTIVE) {
      return (isWhite ? $r('app.media.ic_statusbar_off') : $r('app.media.ic_statusbar_off_black'));
    }
    switch (supportedWifiCategory) {
      case constants.CATEGORY_DEFAULT:
        wifiImage = StatusBarResUtils.getDefaultImage(signalLevel, isWhite);
        break;
      case constants.CATEGORY_WIFI6:
        wifiImage = StatusBarResUtils.getWifi6Image(signalLevel, isWhite);
        break;
      case constants.CATEGORY_WIFI6_PLUS:
        wifiImage = StatusBarResUtils.getWifi6PlusImage(signalLevel, isWhite);
        break;
      case constants.CATEGORY_DOUBLE:
        wifiImage = StatusBarResUtils.getWifiDoubleImage(signalLevel, isWhite);
        break;
      case constants.CATEGORY_DOUBLE_WIFI6:
        wifiImage = StatusBarResUtils.getDoubleWifi6image(signalLevel, isWhite);
        break;
      case constants.CATEGORY_DOUBLE_WIFI6_PLUS:
        wifiImage = StatusBarResUtils.getDoubleWifi6PlusImage(signalLevel, isWhite);
        break;
      case constants.CATEGORY_WIFI7:
        wifiImage = StatusBarResUtils.getWifi7Image(signalLevel, isWhite);
        break;
      case constants.CATEGORY_WIFI7_PLUS:
        wifiImage = StatusBarResUtils.getWifi7PlusImage(signalLevel, isWhite);
        break;
      default:
        wifiImage = StatusBarResUtils.getDefaultImage(signalLevel, isWhite);
        break;
    }
    return wifiImage;
  }

  static getDefaultImage(signalLevel: number, isWhite: boolean): Resource {
    let defaultImage: Resource;
    switch (signalLevel) {
      case constants.WIFI_SIGNAL_NO:
        defaultImage = (isWhite ? $r('app.media.ic_statusbar_wifi_no') : $r('app.media.ic_statusbar_wifi_no_black'));
        break;
      case constants.WIFI_SIGNAL_LOW:
        defaultImage = (isWhite ? $r('app.media.ic_statusbar_wifi_1') : $r('app.media.ic_statusbar_wifi_1_black'));
        break;
      case constants.WIFI_SIGNAL_MID:
        defaultImage = (isWhite ? $r('app.media.ic_statusbar_wifi_2') : $r('app.media.ic_statusbar_wifi_2_black'));
        break;
      case constants.WIFI_SIGNAL_HIGH:
        defaultImage = (isWhite ? $r('app.media.ic_statusbar_wifi_3') : $r('app.media.ic_statusbar_wifi_3_black'));
        break;
      case constants.WIFI_SIGNAL_FULL:
        defaultImage = (isWhite ? $r('app.media.ic_statusbar_wifi_4') : $r('app.media.ic_statusbar_wifi_4_black'));
        break;
      default:
        defaultImage = (isWhite ? $r('app.media.ic_statusbar_wifi_4') : $r('app.media.ic_statusbar_wifi_4_black'));
        break;
    }
    return defaultImage;
  }

  static getWifi6Image(signalLevel: number, isWhite: boolean): Resource {
    let wifi6Image: Resource;
    switch (signalLevel) {
      case constants.WIFI_SIGNAL_NO:
        wifi6Image = (isWhite ? $r('app.media.ic_statusbar_wifi6_0') : $r('app.media.ic_statusbar_wifi6_0_black'));
        break;
      case constants.WIFI_SIGNAL_LOW:
        wifi6Image = (isWhite ? $r('app.media.ic_statusbar_wifi6_1') : $r('app.media.ic_statusbar_wifi6_1_black'));
        break;
      case constants.WIFI_SIGNAL_MID:
        wifi6Image = (isWhite ? $r('app.media.ic_statusbar_wifi6_2') : $r('app.media.ic_statusbar_wifi6_2_black'));
        break;
      case constants.WIFI_SIGNAL_HIGH:
        wifi6Image = (isWhite ? $r('app.media.ic_statusbar_wifi6_3') : $r('app.media.ic_statusbar_wifi6_3_black'));
        break;
      case constants.WIFI_SIGNAL_FULL:
        wifi6Image = (isWhite ? $r('app.media.ic_statusbar_wifi6_4') : $r('app.media.ic_statusbar_wifi6_4_black'));
        break;
      default:
        wifi6Image = (isWhite ? $r('app.media.ic_statusbar_wifi6_4') : $r('app.media.ic_statusbar_wifi6_4_black'));
        break;
    }
    return wifi6Image;
  }

  static getWifi6PlusImage(signalLevel: number, isWhite: boolean): Resource {
    let wifi6PLusImage: Resource;
    switch (signalLevel) {
      case constants.WIFI_SIGNAL_NO:
        wifi6PLusImage = (isWhite ? $r('app.media.ic_statusbar_wifi6plus_0') :
        $r('app.media.ic_statusbar_wifi6plus_0_black'));
        break;
      case constants.WIFI_SIGNAL_LOW:
        wifi6PLusImage = (isWhite ? $r('app.media.ic_statusbar_wifi6plus_1') :
        $r('app.media.ic_statusbar_wifi6plus_1_black'));
        break;
      case constants.WIFI_SIGNAL_MID:
        wifi6PLusImage = (isWhite ? $r('app.media.ic_statusbar_wifi6plus_2') :
        $r('app.media.ic_statusbar_wifi6plus_2_black'));
        break;
      case constants.WIFI_SIGNAL_HIGH:
        wifi6PLusImage = (isWhite ? $r('app.media.ic_statusbar_wifi6plus_3') :
        $r('app.media.ic_statusbar_wifi6plus_3_black'));
        break;
      case constants.WIFI_SIGNAL_FULL:
        wifi6PLusImage = (isWhite ? $r('app.media.ic_statusbar_wifi6plus_4') :
        $r('app.media.ic_statusbar_wifi6plus_4_black'));
        break;
      default:
        wifi6PLusImage = (isWhite ? $r('app.media.ic_statusbar_wifi6plus_4') :
        $r('app.media.ic_statusbar_wifi6plus_4_black'));
        break;
    }
    return wifi6PLusImage;
  }

  static getWifi7Image(signalLevel: number, isWhite: boolean): Resource {
    let wifi7Image: Resource;
    switch (signalLevel) {
      case constants.WIFI_SIGNAL_NO:
        wifi7Image = (isWhite ? $r('app.media.ic_statusbar_wifi7_0') : $r('app.media.ic_statusbar_wifi7_0_black'));
        break;
      case constants.WIFI_SIGNAL_LOW:
        wifi7Image = (isWhite ? $r('app.media.ic_statusbar_wifi7_1') : $r('app.media.ic_statusbar_wifi7_1_black'));
        break;
      case constants.WIFI_SIGNAL_MID:
        wifi7Image = (isWhite ? $r('app.media.ic_statusbar_wifi7_2') : $r('app.media.ic_statusbar_wifi7_2_black'));
        break;
      case constants.WIFI_SIGNAL_HIGH:
        wifi7Image = (isWhite ? $r('app.media.ic_statusbar_wifi7_3') : $r('app.media.ic_statusbar_wifi7_3_black'));
        break;
      case constants.WIFI_SIGNAL_FULL:
        wifi7Image = (isWhite ? $r('app.media.ic_statusbar_wifi7_4') : $r('app.media.ic_statusbar_wifi7_4_black'));
        break;
      default:
        wifi7Image = (isWhite ? $r('app.media.ic_statusbar_wifi7_4') : $r('app.media.ic_statusbar_wifi7_4_black'));
        break;
    }
    return wifi7Image;
  }

  static getWifi7PlusImage(signalLevel: number, isWhite: boolean): Resource {
    let wifi7PLusImage: Resource;
    switch (signalLevel) {
      case constants.WIFI_SIGNAL_NO:
        wifi7PLusImage = (isWhite ? $r('app.media.ic_statusbar_wifi7plus_0') :
        $r('app.media.ic_statusbar_wifi7plus_0_black'));
        break;
      case constants.WIFI_SIGNAL_LOW:
        wifi7PLusImage = (isWhite ? $r('app.media.ic_statusbar_wifi7plus_1') :
        $r('app.media.ic_statusbar_wifi7plus_1_black'));
        break;
      case constants.WIFI_SIGNAL_MID:
        wifi7PLusImage = (isWhite ? $r('app.media.ic_statusbar_wifi7plus_2') :
        $r('app.media.ic_statusbar_wifi7plus_2_black'));
        break;
      case constants.WIFI_SIGNAL_HIGH:
        wifi7PLusImage = (isWhite ? $r('app.media.ic_statusbar_wifi7plus_3') :
        $r('app.media.ic_statusbar_wifi7plus_3_black'));
        break;
      case constants.WIFI_SIGNAL_FULL:
        wifi7PLusImage = (isWhite ? $r('app.media.ic_statusbar_wifi7plus_4') :
        $r('app.media.ic_statusbar_wifi7plus_4_black'));
        break;
      default:
        wifi7PLusImage = (isWhite ? $r('app.media.ic_statusbar_wifi7plus_4') :
        $r('app.media.ic_statusbar_wifi7plus_4_black'));
        break;
    }
    return wifi7PLusImage;
  }

  static getWifiDoubleImage(signalLevel: number, isWhite: boolean): Resource {
    let wifiDoubleImage: Resource;
    switch (signalLevel) {
      case constants.WIFI_SIGNAL_NO:
        wifiDoubleImage = (isWhite ? $r('app.media.ic_statusbar_wifi_double_0') :
        $r('app.media.ic_statusbar_wifi_double_0_black'));
        break;
      case constants.WIFI_SIGNAL_LOW:
        wifiDoubleImage = (isWhite ? $r('app.media.ic_statusbar_wifi_double_1') :
        $r('app.media.ic_statusbar_wifi_double_1_black'));
        break;
      case constants.WIFI_SIGNAL_MID:
        wifiDoubleImage = (isWhite ? $r('app.media.ic_statusbar_wifi_double_2') :
        $r('app.media.ic_statusbar_wifi_double_2_black'));
        break;
      case constants.WIFI_SIGNAL_HIGH:
        wifiDoubleImage = (isWhite ? $r('app.media.ic_statusbar_wifi_double_3') :
        $r('app.media.ic_statusbar_wifi_double_3_black'));
        break;
      case constants.WIFI_SIGNAL_FULL:
        wifiDoubleImage = (isWhite ? $r('app.media.ic_statusbar_wifi_double_4') :
        $r('app.media.ic_statusbar_wifi_double_4_black'));
        break;
      default:
        wifiDoubleImage = (isWhite ? $r('app.media.ic_statusbar_wifi_double_4') :
        $r('app.media.ic_statusbar_wifi_double_4_black'));
        break;
    }
    return wifiDoubleImage;
  }

  static getDoubleWifi6image(signalLevel: number, isWhite: boolean): Resource {
    let doubleWifi6Image: Resource;
    switch (signalLevel) {
      case constants.WIFI_SIGNAL_NO:
        doubleWifi6Image = (isWhite ? $r('app.media.ic_statusbar_wifi6_double_0') :
        $r('app.media.ic_statusbar_wifi6_double_0_black'));
        break;
      case constants.WIFI_SIGNAL_LOW:
        doubleWifi6Image = (isWhite ? $r('app.media.ic_statusbar_wifi6_double_1') :
        $r('app.media.ic_statusbar_wifi6_double_1_black'));
        break;
      case constants.WIFI_SIGNAL_MID:
        doubleWifi6Image = (isWhite ? $r('app.media.ic_statusbar_wifi6_double_2') :
        $r('app.media.ic_statusbar_wifi6_double_2_black'));
        break;
      case constants.WIFI_SIGNAL_HIGH:
        doubleWifi6Image = (isWhite ? $r('app.media.ic_statusbar_wifi6_double_3') :
        $r('app.media.ic_statusbar_wifi6_double_3_black'));
        break;
      case constants.WIFI_SIGNAL_FULL:
        doubleWifi6Image = (isWhite ? $r('app.media.ic_statusbar_wifi6_double_4') :
        $r('app.media.ic_statusbar_wifi6_double_4_black'));
        break;
      default:
        doubleWifi6Image = (isWhite ? $r('app.media.ic_statusbar_wifi6_double_4') :
        $r('app.media.ic_statusbar_wifi6_double_4_black'));
        break;
    }
    return doubleWifi6Image;
  }

  static getDoubleWifi6PlusImage(signalLevel: number, isWhite: boolean): Resource {
    let doubleWifi6PlusImage: Resource;
    switch (signalLevel) {
      case constants.WIFI_SIGNAL_NO:
        doubleWifi6PlusImage = (isWhite ? $r('app.media.ic_statusbar_wifi6plus_double_0') :
        $r('app.media.ic_statusbar_wifi6plus_double_0_black'));
        break;
      case constants.WIFI_SIGNAL_LOW:
        doubleWifi6PlusImage = (isWhite ? $r('app.media.ic_statusbar_wifi6plus_double_1') :
        $r('app.media.ic_statusbar_wifi6plus_double_1_black'));
        break;
      case constants.WIFI_SIGNAL_MID:
        doubleWifi6PlusImage = (isWhite ? $r('app.media.ic_statusbar_wifi6plus_double_2') :
        $r('app.media.ic_statusbar_wifi6plus_double_2_black'));
        break;
      case constants.WIFI_SIGNAL_HIGH:
        doubleWifi6PlusImage = (isWhite ? $r('app.media.ic_statusbar_wifi6plus_double_3') :
        $r('app.media.ic_statusbar_wifi6plus_double_3_black'));
        break;
      case constants.WIFI_SIGNAL_FULL:
        doubleWifi6PlusImage = (isWhite ? $r('app.media.ic_statusbar_wifi6plus_double_4') :
        $r('app.media.ic_statusbar_wifi6plus_double_4_black'));
        break;
      default:
        doubleWifi6PlusImage = (isWhite ? $r('app.media.ic_statusbar_wifi6plus_double_4') :
        $r('app.media.ic_statusbar_wifi6plus_double_4_black'));
        break;
    }
    return doubleWifi6PlusImage;
  }

  static getFlowTypeImage(dataFlowType: number, supportedWifiCategory: number, isMetered: boolean,
    isWhite: boolean): Resource {
    let useDouble : boolean = (supportedWifiCategory >= constants.CATEGORY_WIFI6 &&
      supportedWifiCategory <= constants.CATEGORY_DOUBLE_WIFI6_PLUS);
    if (useDouble || isMetered) {
      return StatusBarResUtils.getFlowTypeImageDouble(dataFlowType, isWhite);
    }
    return StatusBarResUtils.getFlowTypeImageNormal(dataFlowType, isWhite);
  }

  static getFlowTypeImageNormal(dataFlowType: number, isWhite: boolean): Resource {
    let flowTypeImage: Resource;
    switch (dataFlowType) {
      case constants.DATA_FLOW_TYPE_NONE:
        flowTypeImage = (isWhite ? $r('app.media.ic_statusbar_wifi_up_down_no') :
        $r('app.media.ic_statusbar_wifi_up_down_no_black'));
        break;
      case constants.DATA_FLOW_TYPE_DOWN:
        flowTypeImage = (isWhite ? $r('app.media.ic_statusbar_wifi_down') :
        $r('app.media.ic_statusbar_wifi_down_black'));
        break;
      case constants.DATA_FLOW_TYPE_UP:
        flowTypeImage = (isWhite ? $r('app.media.ic_statusbar_wifi_up') : $r('app.media.ic_statusbar_wifi_up_black'));
        break;
      case constants.DATA_FLOW_TYPE_UP_DOWN:
        flowTypeImage = (isWhite ? $r('app.media.ic_statusbar_wifi_up_down') :
        $r('app.media.ic_statusbar_wifi_up_down_black'));
        break;
      default:
        flowTypeImage = (isWhite ? $r('app.media.ic_statusbar_wifi_up_down_no') :
        $r('app.media.ic_statusbar_wifi_up_down_no_black'));
        break;
    }
    return flowTypeImage;
  }

  static getFlowTypeImageDouble(dataFlowType: number, isWhite: boolean): Resource {
    let flowTypeImage: Resource;
    switch (dataFlowType) {
      case constants.DATA_FLOW_TYPE_NONE:
        flowTypeImage = (isWhite ? $r('app.media.ic_statusbar_wifi_double_up_down_no') :
        $r('app.media.ic_statusbar_wifi_double_up_down_no_black'));
        break;
      case constants.DATA_FLOW_TYPE_DOWN:
        flowTypeImage = (isWhite ? $r('app.media.ic_statusbar_wifi_double_down') :
        $r('app.media.ic_statusbar_wifi_double_down_black'));
        break;
      case constants.DATA_FLOW_TYPE_UP:
        flowTypeImage = (isWhite ? $r('app.media.ic_statusbar_wifi_double_up') :
        $r('app.media.ic_statusbar_wifi_double_up_black'));
        break;
      case constants.DATA_FLOW_TYPE_UP_DOWN:
        flowTypeImage = (isWhite ? $r('app.media.ic_statusbar_wifi_double_up_down') :
        $r('app.media.ic_statusbar_wifi_double_up_down_black'));
        break;
      default:
        flowTypeImage = (isWhite ? $r('app.media.ic_statusbar_wifi_double_up_down_no') :
        $r('app.media.ic_statusbar_wifi_double_up_down_no_black'));
        break;
    }
    return flowTypeImage;
  }

  static getNoNetImage(supportedWifiCategory: number, isWhite: boolean): Resource {
    let useDouble : boolean = (supportedWifiCategory >= constants.CATEGORY_WIFI6 &&
      supportedWifiCategory <= constants.CATEGORY_DOUBLE_WIFI6_PLUS);
    if (useDouble) {
      return StatusBarResUtils.getNoNetImageDouble(isWhite);
    }
    return StatusBarResUtils.getNoNetImageNormal(isWhite);
  }

  static getNoNetImageNormal(isWhite: boolean): Resource {
    return (isWhite ? $r('app.media.ic_statusbar_no_net') : $r('app.media.ic_statusbar_no_net_black'));
  }

  static getNoNetImageDouble(isWhite: boolean): Resource {
    return (isWhite ? $r('app.media.ic_statusbar_double_no_net') : $r('app.media.ic_statusbar_double_no_net_black'));
  }

  static getEthernetImage(isWhite: boolean): Resource {
    let ethernetImage: Resource = (isWhite ? $r('app.media.ic_statusbar_ethernet') : $r('app.media.ic_statusbar_ethernet_black'));
    return ethernetImage;
  }

  public static getScreenShotIcon = (isWhite: boolean) => {
    return $r('sys.symbol.rectangle_and_cut')
  }

  public static getSmartScreenShotIcon = (isWhite: boolean) => {
    return $r('sys.symbol.smart_selection_area')
  }

  public static getNoteIcon = (isWhite: boolean) => {
    return $r('sys.symbol.doc_plaintext_and_pencil_fill')
  }

  public static getScreenRecorderIcon = (isWhite: boolean) => {
    return $r('sys.symbol.dot_video_fill');
  }

  public static getVirtualKeyboardIcon = (isWhite: boolean) => {
    return $r('sys.symbol.keyboard_fill');
  }
}