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

import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  HiSysReportEvent,
  ReportDomain,
  ReportParams,
  HiDfxEventUtil
} from '@ohos/frameworkwrapper';
import { VolumeBarAlignRule } from './Constants';

const TAG = 'VolumeSysEventUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 桌面编辑打点上报工具类
 */
export class VolumeSysEventUtil {
  private static readonly VOLUME_UE: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain.VOLUME_UE);

  // 音量调节_音量面板_触发音量面板(按物理键、蓝牙耳机等所有场景)
  public static readonly VOL_PANEL_TRIGGER: string = 'VOL_PANEL_TRIGGER';
  // 音量调节_音量面板_在音量条调节音量
  public static readonly VOL_ADJUSTED: string = 'VOL_ADJUSTED';
  // 音量调节_音量面板_左滑音量条展开音量面板
  public static readonly VOL_BAR_TO_PANEL: string = 'VOL_BAR_TO_PANEL';
  // 音量调节_音量面板_消失打点
  public static readonly VOL_PANEL_BAR_TO_DISAPPEAR: string = 'VOL_PANEL_BAR_TO_DISAPPEAR';
  // 点击音量面板上的设置 打点
  public static readonly VOL_PANEL_CLICK_SETTING: string = 'VOL_PANEL_CLICK_SETTING';
  // 音量面板点击取消静音-通话、媒体、铃声音量 打点
  public static readonly VOL_PANEL_CLICK_CANCEL_MUTE: string = 'VOL_PANEL_CLICK_CANCEL_MUTE';
  // 音量面板点击静音-通话、媒体、铃声音量 打点
  public static readonly VOL_PANEL_CLICK_MUTE: string = 'VOL_PANEL_CLICK_MUTE';
  // 音量调节_音量条_触底触顶打点
  public static readonly VOL_BAR_OVER_TOP_OR_DOWN: string = 'VOL_BAR_OVER_TOP_OR_DOWN';
  // 外设切换刷新最大最小音量值
  public static readonly REFRESH_MAX_AND_MIN_VOLUME: string = 'REFRESH_MAX_AND_MIN_VOLUME';
  // 默认打点间隔延时
  private static VOLUME_REPORT_DELAY_TIME = 500;

  static reportVolumeEvent(name: string, params: VolumeReportParams): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiDfxEventUtil.delayReportEvent(name, params, VolumeSysEventUtil.VOLUME_REPORT_DELAY_TIME, () => {
      VolumeSysEventUtil.VOLUME_UE.reportBehavior(name, params);
    });
  }
}

export class VolumeReportParams {
  public PNAMEID?: string;
  public PVERSIONID?: string;
  public CHANNEL?: number;
  public IS_LOCKED?: number;
  public UI_TYPE?: number;
  public VOLUME?: number;
  public ADJUSTED_TYPE?: number;
  public HINT_TIMES?: number;
  public DISAPPEAR_FROM_UI_TYPE?: number;
  public VOLUME_VAL_TOP_OR_DOWN?: string;
  public MAX_AND_MIN_VOLUME?: string;
}

export class VolumeReportBuilder {
  private param = new VolumeReportParams();

  private constructor() {
  }

  static builder(): VolumeReportBuilder {
    return new VolumeReportBuilder();
  }

  build(): VolumeReportParams {
    return this.param;
  }

  /**
   * 通道类型
   *
   * @param value 类型 0：通话音量, 2：铃声音量, 3：媒体音量
   * @returns VolumeReportBuilder
   */
  channel(value: number): VolumeReportBuilder {
    this.param.CHANNEL = value;
    return this;
  }

  /**
   * 是否在锁屏状态
   *
   * @param value true：是锁屏状态；false：不是
   * @returns VolumeReportBuilder
   */
  isLocked(value: boolean): VolumeReportBuilder {
    this.param.IS_LOCKED = value ? 1 : 0;
    return this;
  }

  /**
   * 音量面板的折叠展开状态
   *
   * @param value 0:折叠（音量条）,1:展开（音量面板）
   * @returns VolumeReportBuilder
   */
  uiType(value: number): VolumeReportBuilder {
    this.param.UI_TYPE = value;
    return this;
  }

  /**
   * 音量大小
   *
   * @param value 音量大小
   * @returns
   */
  volume(value: number): VolumeReportBuilder {
    this.param.VOLUME = value;
    return this;
  }

  /**
   * 调整音量方式
   *
   * @param value 0:按键控制,1:滑动控制
   * @returns
   */
  adjustedType(value: number): VolumeReportBuilder {
    this.param.ADJUSTED_TYPE = value;
    return this;
  }

  /**
   * 音量面板展开时引导次数
   *
   * @param value 音量面板展开时引导次数，-1:无引导
   * @returns
   */
  hintTimes(value: number): VolumeReportBuilder {

    this.param.HINT_TIMES = value;
    return this;
  }

  /**
   * 音量面板消失时是何种类型
   *
   * @param value 0:音量面板,1:细音量条,2:粗音量
   * @returns
   */
  disappearFromUIType(value: number): VolumeReportBuilder {
    this.param.DISAPPEAR_FROM_UI_TYPE = value;
    return this;
  }

  /**
   * 音量条触顶触底
   *
   * @param value: top | down
   * @returns
   */
  volumeValTopOrDown(value: VolumeBarAlignRule): VolumeReportBuilder {
    this.param.VOLUME_VAL_TOP_OR_DOWN = value;
    return this;
  }

  /**
   * 外设切换刷新最大最小音量值
   *
   * @param value: 由通道类型,最大值,最小值拼接的字符串
   * @returns
   */
  maxAndMinVolume(value: string): VolumeReportBuilder {
    this.param.MAX_AND_MIN_VOLUME = value;
    return this;
  }
}
