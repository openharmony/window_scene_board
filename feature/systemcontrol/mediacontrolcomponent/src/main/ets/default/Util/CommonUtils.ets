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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { CheckEmptyUtils } from '@ohos/basicutils/src/main/ets/utils/CheckEmptyUtils';
import audio from '@ohos.multimedia.audio';
import AVSessionManager from '@ohos.multimedia.avsession';
import { constant as bluetoothConstant } from '@kit.ConnectivityKit';
import connection from '@ohos.bluetooth.connection';
import { AVCastPickerDeviceIconName, LyricDataArray } from './Constants';
import { default as SymbolIconUtil } from '@ohos/systemuicommon/src/main/ets/utils/SymbolIconUtil';
import SmartSpeakerIconUtils from './SmartSpeakerIconUtils';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import display from '@ohos.display';
import { ConfigurationConstant } from '@kit.AbilityKit';
// import nearlinkDevice from '@hms.nearlink.remoteDevice';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
// import nearlinkConstant from '@hms.nearlink.constant';
import { distributedDeviceManager } from '@kit.DistributedServiceKit';

const TAG = 'CommonUtils_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const PACKAGE_NAME = 'com.ohos.sceneboard';
// IconId为十六进制
const HEX_RADIX = 16;

export default class CommonUtils {
  private static readonly LOST_DEVICE_TYPE_PC = 8;
  private static readonly imageReg: RegExp = new RegExp(/^data:image.*?;base64,/);

  static getCurSwitchIcon(localDeviceType: number, remoteDeviceType: number) : Resource {
    log.showInfo(`getshowing curswitch : LocalType: ${localDeviceType}, remoteType: ${remoteDeviceType}`);
    if (remoteDeviceType >= 0) {
      switch (remoteDeviceType) {
        case AVSessionManager.DeviceType.DEVICE_TYPE_TV:
          return $r('app.media.ic_device_smartscreen_filled');
        case AVSessionManager.DeviceType.DEVICE_TYPE_SMART_SPEAKER:
          return $r('app.media.ic_device_soundx_filled');
        case AVSessionManager.DeviceType.DEVICE_TYPE_BLUETOOTH:
          return $r('app.media.device_switch_bluetooth');
        case CommonUtils.LOST_DEVICE_TYPE_PC:
          return $r('app.media.ic_device_matebook_filled');
        default:
          return $r('app.media.ic_device_sound_filled');
      }
    }
    switch (localDeviceType) {
      case audio.DeviceType.SPEAKER:
        return $r('app.media.ic_devicebtn');
      case audio.DeviceType.USB_HEADSET:
        return $r('app.media.device_switch_earphone');
      case audio.DeviceType.BLUETOOTH_A2DP:
        return $r('app.media.device_switch_bluetooth');
      case audio.DeviceType.WIRED_HEADPHONES:
        return $r('app.media.device_switch_earphone');
      default:
        return $r('app.media.device_switch_earphone');
    }
  }


  // 显示车机图标
  public static isShowCarIcon(networkId: string | undefined, deviceType: audio.DeviceType): boolean {
    return networkId !== 'LocalDevice' && !!AppStorage.get('isConnectedPadCar') && deviceType === audio.DeviceType.SPEAKER && !!networkId;
  }

  // 显示分布式设备
  public static isSupportDistributeScene(networkId: string | undefined): boolean {
    return networkId !== 'LocalDevice';
  }

  /**
   * 获取当前需要显示的蓝牙图标
   * @param deviceMac 设备mac地址
   * @returns value 返回蓝牙图标名称
   */
  public static getBluetoothFillIcon(deviceMac?: string): string {
    let iconString: string = SymbolIconUtil.getEarphoneFillIcon(deviceMac);
    if (iconString.includes('sys.symbol.earphone')) {
      // 包含earphone字段返回获取到的耳机图标
      return iconString;
    }
    if (deviceMac) {
      iconString = SmartSpeakerIconUtils.getSpeakerIconByModelId(SmartSpeakerIconUtils.getRemoteProductId(deviceMac));
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

  private static getNearlinkIconByIconId(iconId: string) {
    try {
      const decimalIconId: number = parseInt(iconId, HEX_RADIX);
      const symbolName: string = `earphone_${decimalIconId}_fill`;
      // 检查图标标识是否在Symbol中，不存在会走catch分支
      GlobalContext.getContext().resourceManager.getSymbolByName(symbolName);
      // 耳机的资源文件在Symbol中，且id范围合法，按资源名返回
      return `sys.symbol.${symbolName}`;
    } catch (e) {
      log.showError(`SCB getNearlinkIconByIconId error code: ${e?.code}, message: ${e?.message}`);
      return '';
    }
  }
  /**
   * 获取当前需要显示的星闪图标
   * @param deviceMac 设备mac地址
   * @returns value 返回星闪图标名称
   */
  public static getNearlinkFillIcon(deviceMac?: string): string {
    log.showInfo(`SCB getNearlinkFillIcon enter`);
    if (CheckEmptyUtils.checkStrIsEmpty(deviceMac)) {
      return AVCastPickerDeviceIconName.NEARLINK_SYMBOL;
    }
    // let device: nearlinkDevice.RemoteDevice | undefined = undefined;
    // let deviceModel: nearlinkDevice.DeviceModel | undefined = undefined;
    let iconString: string;
    try {
      log.showInfo(`SCB getNearlinkFillIcon start createRemoteDevice`);
      // device = nearlinkDevice.createRemoteDevice(deviceMac);
      // deviceModel = device.getDeviceModel();
      // iconString = CommonUtils.getNearlinkIconByIconId(deviceModel.iconId);
      // 能通过macId从耳机图标库获取到iconId的情况
      // if (iconString.includes('sys.symbol.earphone')) {
        // 包含earphone字段返回获取到的耳机图标
        // log.showInfo(`SCB getNearlinkFillIcon from iconId`);
        // return iconString;
      // }
    } catch (e) {
      log.showError(`SCB getNearlinkFillIcon getDeviceModel error code: ${e?.code}, message: ${e?.message}`);
    }
    // if (deviceModel) {
    //   // 通过modelId获取图标
    //   iconString = SmartSpeakerIconUtils.getSpeakerIconByModelId(deviceModel.modelId);
    //   if (iconString !== undefined && iconString !== '') {
    //     log.showInfo(`SCB getNearlinkFillIcon from modelId`);
    //     return iconString;
    //   }
    // }
    try {
      // 判断当前是否是音响图标
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

  /**
   * JSON.stringify过滤key对应的属性
   * @param key 属性
   * @param value 值
   * @returns value 返回undefined当前key过滤
   */
  public static stringifyReplacer(key: string, value: ESObject): ESObject {
    if (key === 'deviceAddress') {
      // 过滤掉deviceAddress属性
      return undefined;
    }
    // 其他属性不变
    return value;
  }

  /**
   * 日志打印掩码
   *
   * @param str 字符串
   * @returns res 返回''或者本身或者加入掩码的字符串
   */
  public static getMaskStr(str: string): string {
    let res: string = '';
    try {
    if (str === undefined) {
      return res;
    }
    let saveLen: number = 5;
    let len: number = str.length as number;
    if (len <= 2 * saveLen) {
      return str;
    }
    let maskStr: string = '********';
    res = str.substring(0, saveLen) + maskStr + str.substring(len - saveLen, len);
    } catch (e) {
      log.error(TAG, 'getMaskStr error');
    }
    return res;
  }

  /**
   * 判断是否是播放状态
   *
   */
  public static isPlaying(currentPlayState: number, lastPlayState: number, isCasting: boolean): boolean {
    if (isCasting) {
      return !!(currentPlayState === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY ||
        (currentPlayState === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING &&
          lastPlayState === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY))
    } else {
      return !!(currentPlayState === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY ||
        currentPlayState === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING)
    }
  }

  /*
  * @description 处理歌词时间
  * @param string 歌词时间 格式: 00:00.00
  * @return number 毫秒时间
  */
  public static handleLyricTime(originalTime: string): number {
    const minute = Number(originalTime.slice(0, originalTime.indexOf(':'))); // 分钟
    const second = Number(originalTime.slice(originalTime.indexOf(':') + 1, originalTime.indexOf('.'))); // 秒
    const millisecond = Number(originalTime.slice(originalTime.indexOf('.') + 1)); // 毫秒
    return minute * 60 * 1000 + second * 1000 + millisecond || 0;
  }

  /**
   * 是否是三屏设备并且是G态
   *
   * @returns true是，false不是
   */
  public static isUltraScreenProductInGState(): boolean {
    return DeviceHelper.isUltraScreenProduct() && DeviceHelper.isGState();
  }

  /**
   * 是否是折疊屏设备并且是折疊态
   *
   * @returns true是，false不是
   */
  public static isFoldExpanded(): boolean {
    let isFoldExpanded: boolean = false;
    try {
      isFoldExpanded = display.isFoldable() && (display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED ||
        CommonUtils.isUltraScreenProductInGState());
      log.showInfo(`isFoldExpanded : getFoldStatus = ${display.getFoldStatus()},isFoldExpanded = ${isFoldExpanded}`);
    } catch (error) {
      log.showError('isFoldExpanded -> try error:', error);
    }
    return isFoldExpanded;
  }

  /**
   * 是否是深色模式
   *
   * @returns true是，false不是
   */
  public static isDarkMode(currColorMode: number): boolean {
    return currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  }

  /**
   * 解析LRC格式的歌词
   * @param lyricList
   * @returns
   */
  public static analyzeLyric(lyricList: string[]): LyricDataArray[] {
    log.showInfo(`analyzeLyric start`);
    const headerRegex: RegExp = new RegExp(/^\[.+\]$/); // LRC歌词头信息
    const contentRegex: RegExp = new RegExp(/^\[\d{1,2}:\d{1,2}\.\d{1,3}\].*$/); // LRC歌词内容
    let dataArray: LyricDataArray[] = [];
    let isError: boolean = false;
    lyricList.forEach((item: string, index: number) => {
      item = item.trim();
      if (isError) {
        return;
      }
      if (contentRegex.test(item)) {
        // 匹配歌词
        const lyricItemTime = item.replace('[', '').split(']')[0];
        dataArray.push({
          index: index,
          time: CommonUtils.handleLyricTime(lyricItemTime),
          originalTime: lyricItemTime,
          lyric: item.replace('[', '').split(']')[1] || ''
        })
      } else if (!headerRegex.test(item) && item.length > 0) {
        // 不匹配歌词，也不匹配头信息
        isError = true;
        dataArray = [];
      }
    })
    log.showInfo(`analyzeLyric end, length = ${dataArray.length}`);
    return dataArray;
  }

  /**
   * 验证图片地址是否是base64
   * @param src
   * @returns
   */
  public static isBase64Image(src: string) {
    return CommonUtils.imageReg.test(src);
  }

  static async getLocalDeviceName(): Promise<string> {
    let deviceName: string = '';
    try {
      let dmInstance: distributedDeviceManager.DeviceManager =
        distributedDeviceManager.createDeviceManager(PACKAGE_NAME);
      deviceName = await dmInstance.getLocalDisplayDeviceName(0);
    } catch (err) {
      console.error('createDeviceManager errCode:' + err.code + ',errMessage:' + err.message);
    }
    return deviceName;
  }

  /**
   * 数据脱敏
   * @param data
   * @returns
   */
  public static desensitize(data: string | undefined): string {
    let result: string = data || '';
    if (result.length > 10) {
      result = `${result.substring(0, 5)}**${result.substring(result.length - 5)}`;
    }
    return result;
  }
}