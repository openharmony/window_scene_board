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

import { GlobalContext } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import connection from '@ohos.bluetooth.connection';
import constant from '@ohos.bluetooth.constant';
import { HashMap } from '@kit.ArkTS';
import { constant as bluetoothConstant } from '@kit.ConnectivityKit';
import audio from '@ohos.multimedia.audio';
// import nearlinkDevice from '@hms.nearlink.remoteDevice';
// import nearlinkConstant from '@hms.nearlink.constant';

const TAG = 'SymbolIconUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

// IconId为十六进制
const HEX_RADIX = 16;

/**
 * 设备symbol库图标名称
 */
export enum AVCastPickerDeviceIconName {
  WIRED_SYMBOL = 'sys.symbol.earphone_16640_fill',
  EARPIECE_SYMBOL = 'sys.symbol.ear',
  SPEAKER_SYMBOL = 'sys.symbol.speaker_wave_2_fill',
  BLUETOOTH_SYMBOL = 'sys.symbol.bluetooth',
  PHONE_SYMBOL = 'sys.symbol.phone_fill_1',
  PAD_SYMBOL = 'sys.symbol.pad_fill',
  MATEBOOK_SYMBOL = 'sys.symbol.matebook_fill',
  SOUND_BOX_SYMBOL = 'sys.symbol.soundx_fill',
  CAST_MORE_SYMBOL = 'sys.symbol.smart_speaker_fill',
  CAST_STREAM_SYMBOL = 'sys.symbol.shareplay',
  CAST_SCREEN_SYMBOL = 'sys.symbol.wireless_projection',
  SELECTED_ICON_SYMBOL = 'sys.symbol.checkmark',
  SOUND_MINUS_SYMBOL = 'sys.symbol.speaker_wave_1_fill',
  SOUND_PLUS_SYMBOL = 'sys.symbol.speaker_wave_3_fill',
  CAR_SYMBOL = 'sys.symbol.car_fill',
  NEARLINK_SYMBOL = 'sys.symbol.nearlink',
  EGRETTA_SYMBOL = 'sys.symbol.egretta_fill',
  SOUND_AI_SYMBOL = 'sys.symbol.soundai_fill',
  EARPHONE_SYMBOL = 'sys.symbol.earphone_16646_fill',
  SKYLARK_SYMBOL = 'sys.symbol.skylark_fill',
}

class SymbolIconUtil {
  // 蓝牙Symbol资源
  public static readonly DEFAULT_BLUETOOTH_SYMBOL_ICON = 'sys.symbol.bluetooth';
  // 耳机盒Symbol资源
  public static readonly DEFAULT_CASE_SYMBOL_ICON = 'sys.symbol.earphone_case_bluetooth';
  // 耳机Symbol资源
  public static readonly DEFAULT_EARPHONE_SYMBOL_ICON = 'sys.symbol.earphone_bluetooth_fill';
  public static iconMap: HashMap<string, string> = new HashMap();
  public static validModel = ['X', '0070', '000027'];

  static {
    SymbolIconUtil.iconMap.set('X0A2', AVCastPickerDeviceIconName.SKYLARK_SYMBOL);
    SymbolIconUtil.iconMap.set('X0A4', AVCastPickerDeviceIconName.EGRETTA_SYMBOL);
    SymbolIconUtil.iconMap.set('X0A3', AVCastPickerDeviceIconName.EGRETTA_SYMBOL);
    SymbolIconUtil.iconMap.set('X007', AVCastPickerDeviceIconName.EGRETTA_SYMBOL);
    SymbolIconUtil.iconMap.set('X006', AVCastPickerDeviceIconName.SOUND_AI_SYMBOL);
    SymbolIconUtil.iconMap.set('X005', AVCastPickerDeviceIconName.SOUND_AI_SYMBOL);
    SymbolIconUtil.iconMap.set('X0A5', AVCastPickerDeviceIconName.SOUND_BOX_SYMBOL);
    SymbolIconUtil.iconMap.set('X0A0', AVCastPickerDeviceIconName.SOUND_BOX_SYMBOL);
    SymbolIconUtil.iconMap.set('0070', AVCastPickerDeviceIconName.SOUND_BOX_SYMBOL);
    SymbolIconUtil.iconMap.set('000027', AVCastPickerDeviceIconName.EARPHONE_SYMBOL);
  }

  public getProductId(deviceMac: string): string[] {
    try {
      // 根据mac获取对应设备信息, 不存在id时会返回FFFFFF_FF_FFFF
      const productId: string = connection.getRemoteProductId(deviceMac);
      const result: string[] = productId.split('_');
      // 最后的id为iconID
      return result;
    } catch (e) {
      log.showWarn(`getProductId error: ${e?.code}, ${e?.message}`);
      return [];
    }
  }

  /**
   * 判断是否蓝牙音频设备（耳机、眼镜、...)
   */
  isHUAWEIAudioDevice(mac: string): boolean {
    if (this.getProductId(mac)[0] !== 'FFFFFF' && this.isEarphone(mac)) {
      return true;
    }
    return false;
  }

  /**
   * 是否是耳机
   * @param deviceMac 设备mac
   * @returns true 是耳机类型
   */
  public isEarphone(deviceMac: string): boolean {
    try {
      const deviceClass: connection.DeviceClass = connection.getRemoteDeviceClass(deviceMac);
      if (deviceClass.majorClass === constant.MajorClass.MAJOR_AUDIO_VIDEO &&
        (deviceClass.majorMinorClass === constant.MajorMinorClass.AUDIO_VIDEO_WEARABLE_HEADSET ||
          deviceClass.majorMinorClass === constant.MajorMinorClass.AUDIO_VIDEO_HEADPHONES)) {
        log.showInfo('isEarphone the mac major is audio video');
        return true;
      }
      return false;
    } catch (e) {
      log.showError(`isEarphone error: ${e?.code}, ${e?.message}`);
      return false;
    }
  }

  /**
   * 获取耳机面性图的Symbol字符串
   *
   * @returns Symbol字符串
   */
  public getEarphoneFillIcon(deviceMac?: string): string {
    const iconString: string = this.getEarphoneIcon(deviceMac);
    if (iconString.includes('sys.symbol.earphone')) {
      // 包含earphone字段返回获取到的耳机图标
      return iconString;
    }
    // 返回蓝牙图标
    return SymbolIconUtil.DEFAULT_BLUETOOTH_SYMBOL_ICON;
  }

  /**
   * 获取耳机Symbol图标
   *
   * @returns Symbol图标的value
   */
  private getEarphoneIcon(deviceMac?: string): string {
    try {
      const productId: string[] = this.getProductId(deviceMac);
      if (productId.length === 0) {
        return '';
      }
      const iconId: number = parseInt(productId[productId.length - 1], HEX_RADIX);
      const symbolName: string = `earphone_${iconId}_fill`;
      // 检查图标标识是否在Symbol中，不存在会走catch分支
      GlobalContext.getContext().resourceManager.getSymbolByName(symbolName);
      // 耳机的资源文件在Symbol中，且id范围合法，按资源名返回
      return `sys.symbol.${symbolName}`;
    } catch (e) {
      log.showWarn(`getEarphoneIcon error code` + e?.code + ', message:' + e?.message);
      if (this.isEarphone(deviceMac)) {
        return SymbolIconUtil.DEFAULT_EARPHONE_SYMBOL_ICON;
      }
      return '';
    }
  }

  /**
   * 获取耳机盒Symbol图标
   *
   * @returns Symbol图标的value
   */
  public getEarphoneCaseIcon(deviceMac?: string): string {
    try {
      const productId: string[] = this.getProductId(deviceMac);
      if (productId.length === 0) {
        return SymbolIconUtil.DEFAULT_CASE_SYMBOL_ICON;
      }
      const iconId: number = parseInt(productId[productId.length - 1], HEX_RADIX);
      const symbolName: string = `earphone_case_${iconId}`;
      // 检查图标标识是否在Symbol中，不存在会走catch分支
      GlobalContext.getContext().resourceManager.getSymbolByName(symbolName);
      // 耳机的资源文件在Symbol中，且id范围合法，按资源名返回
      return `sys.symbol.${symbolName}`;
    } catch (e) {
      log.showWarn(`getEarphoneIcon error code` + e?.code + ', message:' + e?.message);
      return SymbolIconUtil.DEFAULT_CASE_SYMBOL_ICON;
    }
  }

  /**
   * 校验modelId是否合法
   *
   * @param modelId 产品Id
   * @returns
   */
  public isValidSmartSpeaker(modelId: string): boolean {
    if (!modelId) {
      return false;
    }
    let idx = SymbolIconUtil.validModel.findIndex((validModelId) => modelId.startsWith(validModelId));
    return idx !== -1;
  }

  /**
   * 通过modelId获取图标名称
   *
   * @param modelId 产品Id
   * @returns 图标名称
   */
  public getSpeakerIconByModelId(modelId: string): string {
    if (!modelId || !this.isValidSmartSpeaker(modelId)) {
      return '';
    }
    let iconId = SymbolIconUtil.iconMap.get(modelId);
    if (iconId) {
      return iconId;
    }
    return AVCastPickerDeviceIconName.CAST_MORE_SYMBOL;
  }

  /**
   * 通过mac地址获取modelId
   *
   * @param address mac地址
   * @returns modelId
   */
  public getRemoteProductId(address: string): string {
    let modelId = '';
    try {
      let productInfo = connection.getRemoteProductId(address);
      let infos: string[] = productInfo.split('_');
      if (infos.length > 0) {
        modelId = infos[0];
      }
      log.showInfo(`product info: ${productInfo}`);
    } catch (e) {
      log.showError('get remote product id error.');
    }
    return modelId;
  }

  /**
   * 获取当前需要显示的蓝牙图标
   * @param deviceMac 设备mac地址
   * @returns value 返回蓝牙图标名称
   */
  public getBluetoothFillIcon(deviceMac?: string): string {
    let iconString: string = this.getEarphoneFillIcon(deviceMac);
    if (iconString.includes('sys.symbol.earphone')) {
      // 包含earphone字段返回获取到的耳机图标
      return iconString;
    }
    if (deviceMac) {
      iconString = this.getSpeakerIconByModelId(this.getRemoteProductId(deviceMac));
      if (iconString !== undefined && iconString !== '') {
        return iconString;
      }
    }
    // 判断当前是否是音响图标
    let deviceClass: connection.DeviceClass | undefined = undefined;
    try {
      deviceClass = connection.getRemoteDeviceClass(deviceMac);
    } catch (err) {
      log.showInfo(TAG, 'Faild to get deviceClass');
    }

    if (!deviceClass || !deviceClass.majorClass) {
      return AVCastPickerDeviceIconName.BLUETOOTH_SYMBOL;
    }
    if (deviceClass.majorClass === bluetoothConstant.MajorClass.MAJOR_AUDIO_VIDEO &&
      deviceClass.majorMinorClass === bluetoothConstant.MajorMinorClass.AUDIO_VIDEO_LOUDSPEAKER) {
      return AVCastPickerDeviceIconName.SOUND_BOX_SYMBOL;
    }
    return AVCastPickerDeviceIconName.BLUETOOTH_SYMBOL;
  }

  /**
   * 获取当前需要显示的星闪图标
   * @param deviceMac 设备mac地址
   * @returns value 返回星闪图标名称
   */
  public getNearlinkFillIcon(deviceMac?: string): string {
    log.showInfo(`CC getNearlinkFillIcon enter`);
    if (CheckEmptyUtils.checkStrIsEmpty(deviceMac)) {
      return AVCastPickerDeviceIconName.NEARLINK_SYMBOL;
    }
    // let device: nearlinkDevice.RemoteDevice | undefined = undefined;
    // let deviceModel: nearlinkDevice.DeviceModel | undefined = undefined;
    let iconString: string;
    try {
      log.showInfo(`CC getNearlinkFillIcon start createRemoteDevice`);
      // device = nearlinkDevice.createRemoteDevice(deviceMac);
      // deviceModel = device.getDeviceModel();
      // iconString = this.getNearlinkIconByIconId(deviceModel.iconId);
      // 能通过macId从耳机图标库获取到iconId的情况
      if (iconString.includes('sys.symbol.earphone')) {
        // 包含earphone字段返回获取到的耳机图标
        log.showInfo(`SCB getNearlinkFillIcon from iconId`);
        return iconString;
      }
    } catch (e) {
      log.showError(`SCB getNearlinkFillIcon getDeviceModel error code: ${e?.code}, message: ${e?.message}`);
    }
    // if (deviceModel) {
    //   // 通过modelId获取图标
    //   iconString = this.getSpeakerIconByModelId(deviceModel.modelId);
    //   if (iconString !== undefined && iconString !== '') {
    //     log.showInfo(`SCB getNearlinkFillIcon from modelId`);
    //     return iconString;
    //   }
    // }
    try {
      // // 判断当前是否是音响图标
      // let deviceClass: nearlinkConstant.DeviceClass | undefined = device?.getDeviceClass();
      // if (deviceClass === nearlinkConstant.DeviceClass.DEVICE_SMART_SPEAKER) {
      //   log.showInfo(`SCB getNearlinkFillIcon device Class is sound box`);
      //   return AVCastPickerDeviceIconName.SOUND_BOX_SYMBOL;
      // }
    } catch (e) {
      log.showError(`SCB getNearlinkFillIcon device class error code: ${e?.code}, message: ${e?.message}`);
    }
    log.showInfo(`SCB getNearlinkFillIcon from default`);
    return AVCastPickerDeviceIconName.NEARLINK_SYMBOL;
  }

  private getNearlinkIconByIconId(iconId: string): string {
    try {
      const decimalIconId: number = parseInt(iconId, HEX_RADIX);
      const symbolName: string = `earphone_${decimalIconId}_fill`;
      // 检查图标标识是否在Symbol中，不存在会走catch分支
      GlobalContext.getContext().resourceManager.getSymbolByName(symbolName);
      // 耳机的资源文件在Symbol中，且id范围合法，按资源名返回
      return `sys.symbol.${symbolName}`;
    } catch (e) {
      log.showError(`CC getNearlinkIconByIconId error code: ${e?.code}, message: ${e?.message}`);
      return '';
    }
  }
}

export default new SymbolIconUtil();