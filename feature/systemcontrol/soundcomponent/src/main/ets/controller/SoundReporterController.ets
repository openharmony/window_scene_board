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

import hiSysEvent from '@ohos.hiSysEvent';
import audio from '@ohos.multimedia.audio';
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  HiSysEventUtil,
  NTFControlParams,
  ReportDomain,
  DeviceHelper,
} from '@ohos/frameworkwrapper';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { DeviceInfoBean } from '../common/DeviceInfoBean';
import SoundDataShareController from './SoundDataShareController';

const TAG = 'SoundReporterController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

class CCVoiceParams extends NTFControlParams {
  public DEVICE_TYPE: string = '';
  public DEVICE_NAME: string = '';
  public DEVICE_SN: string = '';
  public MODEL_ID: string = '';
  public SUB_MODEL: string = '';
  public VERSION: string = '';
  public TIMESTAMP: string = '';
  public VALUE?: number;
  public SCREENTYPE?: number;
  public LOCKSTATUS?: number;

  constructor() {
    super();
    this.TIMESTAMP = `${Date.now()}`;
  }
}

class SceneBoardSoundParams extends NTFControlParams {
  public DEVICE_NAME: string = '';
  public DEVICE_SN: string = '';
  public MODEL_ID: string = '';
  public SUB_MODEL: string = '';
  public TIMESTAMP: string = '';
  public VALUE?: number;

  constructor() {
    super();
    this.TIMESTAMP = `${Date.now()}`;
  }
}

enum VoiceReportEventEnum {
  /**
   * 控制中心_声音按钮_点击跳转到二级界面
   */
  CONTROL_CENTER_VOICE_CLICK = 'CONTROL_CENTER_VOICE_CLICK',
  /**
   * 控制中心_声音二级界面_点击噪声控制开关
   */
  CONTROL_CENTER_VOICE_NOISE = 'CONTROL_CENTER_VOICE_NOISE',
  /**
   * 控制中心_声音二级界面_点击空间音频开关
   */
  CONTROL_CENTER_VOICE_SPATIAL = 'CONTROL_CENTER_VOICE_SPATIAL',
  /**
   * 控制中心_声音二级界面_调节音量大小
   */
  CONTROL_CENTER_VOICE_VOLUME = 'CONTROL_CENTER_VOICE_VOLUME',
  /**
   * 控制中心_声音二级界面_点击设备标题进入单品页面
   */
  CONTROL_CENTER_VOICE_TITLE = 'CONTROL_CENTER_VOICE_TITLE',
}

enum SceneBoardSoundReportEventEnum {
  /**
   * PC状态栏_声音_下拉菜单_设备初始值或点击设备切换打点
   */
  SOUND_DEVICE_MENU_CLICK = 'SOUND_DEVICE_MENU_CLICK',
  /**
   * PC状态栏_声音_下拉菜单_点击设置降噪模式打点
   */
  SOUND_DEVICE_NOISE = 'SOUND_DEVICE_NOISE',
  /**
   * PC状态栏_声音_下拉菜单_点击设置空间音频模式打点
   */
  SOUND_DEVICE_SPATIAL = 'SOUND_DEVICE_SPATIAL',
}

// PC状态栏_声音_下拉菜单_首次展开菜单打点value
const SCENE_BOARD_SHOW_MENU = 0;

// PC状态栏_声音_下拉菜单_点击设备切换打点value
const SCENE_BOARD_DEVICE_CHANGE = 1;

// 手机控制中心_声音二级页_点击降噪或空间音频切换按钮打点value
const NOISE_OR_SPATIAL_SWITCH = 3;

class SoundReporterController {
  /**
   * 点击声音按钮进入二级页面打点
   *
   * @param outputDevice出声设备
   */
  public clickVoiceButtonReport(outputDevice?: audio.AudioDeviceDescriptor): void {
    this.reportControlCenterVoice(VoiceReportEventEnum.CONTROL_CENTER_VOICE_CLICK, outputDevice?.address,
      outputDevice?.deviceType);
  }

  /**
   * 点击二级页面标题跳转打点
   *
   * @param outputDevice 出声设备
   */
  public clickDeviceTitleReport(outputDevice?: audio.AudioDeviceDescriptor): void {
    this.reportControlCenterVoice(VoiceReportEventEnum.CONTROL_CENTER_VOICE_TITLE, outputDevice?.address,
      outputDevice?.deviceType);
  }

  /**
   * 点击二级页面降噪打点
   *
   * @param outputDevice出声设备
   * @param value 降噪类型 默认值 3为切换按钮
   */
  public clickNoiseReport(outputDevice?: audio.AudioDeviceDescriptor, value: number = NOISE_OR_SPATIAL_SWITCH): void {
    this.reportControlCenterVoice(VoiceReportEventEnum.CONTROL_CENTER_VOICE_NOISE, outputDevice?.address,
      outputDevice?.deviceType, value);
  }

  /**
   * 点击二级页面空间音频打点
   *
   * @param outputDevice出声设备
   * @param value 空间音频类型 默认值 3为切换按钮
   */
  public clickSpatialReport(outputDevice?: audio.AudioDeviceDescriptor, value: number = NOISE_OR_SPATIAL_SWITCH): void {
    this.reportControlCenterVoice(VoiceReportEventEnum.CONTROL_CENTER_VOICE_SPATIAL, outputDevice?.address,
      outputDevice?.deviceType, value);
  }

  /**
   * 调节二级页面音量打点
   *
   * @param deviceType 设备类型
   * @param mac 设备mac
   * @param value 音量值
   */
  public changeVoicePageVolumeReport(deviceType: number, mac: string, value: number): void {
    this.reportControlCenterVoice(VoiceReportEventEnum.CONTROL_CENTER_VOICE_VOLUME, mac, deviceType, value);
  }

  /**
   * 点击PC状态栏声音展开菜单打点
   * @param mac 耳机mac
   */
  public clickPcSoundMenuReport(mac: string): void {
    this.reportSceneBoardSound(SceneBoardSoundReportEventEnum.SOUND_DEVICE_MENU_CLICK, mac, SCENE_BOARD_SHOW_MENU);
  }

  /**
   * 点击PC状态栏声音设置出声设备打点
   * @param mac 耳机mac
   */
  public changePcSoundDeviceReport(mac: string): void {
    this.reportSceneBoardSound(SceneBoardSoundReportEventEnum.SOUND_DEVICE_MENU_CLICK, mac, SCENE_BOARD_DEVICE_CHANGE);
  }

  /**
   * 点击PC状态栏声音设置降噪打点
   * @param mac 耳机mac
   * @param value 降噪值
   */
  public clickPcSoundNoiseReport(mac: string, value: number): void {
    this.reportSceneBoardSound(SceneBoardSoundReportEventEnum.SOUND_DEVICE_NOISE, mac, value);
  }

  /**
   * 点击PC状态栏声音设置空间音频打点
   * @param mac 耳机mac
   * @param value 空间音频值
   */
  public clickPcSoundSpatialReport(mac: string, value: number): void {
    this.reportSceneBoardSound(SceneBoardSoundReportEventEnum.SOUND_DEVICE_SPATIAL, mac, value);
  }

  /**
   * 点击phone控制中心声音打点
   * @param event 打点事件
   * @param mac 设备mac
   * @param deviceType 设备类型
   * @param value 打点的value
   */
  private async reportControlCenterVoice(event: VoiceReportEventEnum, mac: string = '',
    deviceType: number = audio.DeviceType.INVALID, value?: number): Promise<void> {
    // log.showInfo(`reportControlCenterVoice event: ${event}, ${convertMac(mac)}`);
    const params: CCVoiceParams = new CCVoiceParams();
    const deviceInfo: DeviceInfoBean | null = await SoundDataShareController.queryDeviceInfo(mac);
    if (deviceInfo) {
      // 等待设备信息成功获取后返回参数进行打点
      params.DEVICE_NAME = deviceInfo.deviceName;
      params.DEVICE_SN = deviceInfo.sn;
      params.MODEL_ID = deviceInfo.modelId;
      params.SUB_MODEL = deviceInfo.subModelId;
      params.VERSION = deviceInfo.deviceSoftVersion;
    }
    params.DEVICE_TYPE = `${deviceType}`;
    params.VALUE = value;
    params.SCREENTYPE = 0;
    params.LOCKSTATUS = AppStorage.get('lockStatus');
    HiSysEventUtil.reportEvent(event, params, hiSysEvent.EventType.BEHAVIOR, ReportDomain.CONTROLCENTER_UE);
  }

  /**
   * 点击pc状态栏声音展开菜单及设备切换打点
   * @param event 打点事件
   * @param mac 设备mac
   * @param value 打点的value
   */
  private async reportSceneBoardSound(event: SceneBoardSoundReportEventEnum, mac: string,
    value: number): Promise<void> {
    // log.showInfo(`reportSceneBoardSound ${event}, ${convertMac(mac)}`);
    const params: SceneBoardSoundParams = new SceneBoardSoundParams();
    const deviceInfo: DeviceInfoBean | null = await SoundDataShareController.queryDeviceInfo(mac);
    if (deviceInfo) {
      // 等待设备信息成功获取后返回参数进行打点
      params.DEVICE_NAME = deviceInfo.deviceName;
      params.DEVICE_SN = deviceInfo.sn;
      params.MODEL_ID = deviceInfo.modelId;
      params.SUB_MODEL = deviceInfo.subModelId;
    }
    params.VALUE = value;
    HiSysEventUtil.reportEvent(event, params, hiSysEvent.EventType.BEHAVIOR, ReportDomain.CONTROLCENTER_UE);
  }
}

export default new SoundReporterController();
