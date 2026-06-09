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
import type image from '@ohos.multimedia.image';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/commonconstants';
import type NtfMgr from '@ohos.notificationManager';
import type { ILiveExtendData } from '../../common/ILiveExtendData';
import { LiveExtendType, SysTypeCode } from '../../common/LiveConstants';
import { LiveButtonArray } from '../../data/extend/LiveButtonData';
import { LiveProgressData } from '../../data/extend/LiveProgressData';
import { LiveTimerData } from '../../data/extend/LiveTimerData';
import { LiveSystemTemplate } from '../../data/template/LiveSystemTemplate';
import { BaseDataParser } from '../interface/BaseDataParser';
import type { Parse } from '../interface/Parse';
import { OverlayIconStyle } from '../../../model/NotificationContent';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'LiveSystemTemplateParser';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 系统卡片模板数据解析器
 */
export class LiveSystemTemplateParser implements Parse<LiveSystemTemplate> {
  /**
   * 用于解析系统卡片模板扩展数据的责任链
   */
  private headParser: BaseDataParser<ILiveExtendData>;

  constructor() {
    this.init();
  }

  /**
   * 模板数据解析
   *
   * @param request 实况通知请求
   * @returns 解析完毕的实况通知数据
   */
  parse(request: NtfMgr.NotificationRequest): LiveSystemTemplate | undefined {
    if (CommonUtils.isInvalid(request)) {
      log.showWarn('sys parse warn: request is null');
      return undefined;
    }
    let newData = new LiveSystemTemplate();
    newData.setTitle(request.content?.systemLiveView?.title);
    newData.setContent(request.content?.systemLiveView?.text);
    newData.setOverlayIcon(request.overlayIcon);
    newData.setOverlayIconStyle(request.extraInfo?.openharmony_overlay_style ?? OverlayIconStyle.CIRCLE);
    newData.setWantAgent(request.wantAgent);
    // 将解析系统卡片扩展区数据的任务交给责任链
    this.headParser.parse(request, newData);

    // 通话类型，允许SIM卡标
    let typCode = request.content?.systemLiveView?.typeCode;
    if (typCode === SysTypeCode.PHONE) {
      let status = request.extraInfo?.openharmony_sim_icon_status;
      if (CommonUtils.isNumber(status)) {
        newData.setSimIconStatus(status);
      }
    }
    return newData;
  }

  /**
   * 用于解析系统卡片模板扩展数据的责任链
   */
  private init(): void {
    this.headParser = new TimeParser();
    this.headParser.setNextParser(new ProgressParser());
    this.headParser.getNextParser().setNextParser(new ButtonParser());
  }
}


/**
 * 系统卡片模板时间扩展类数据解析器
 */
class TimeParser extends BaseDataParser<ILiveExtendData> {
  /**
   * 解析倒计时类数据
   *
   * @param request 实况请求
   * @param template LiveSystemTemplate
   */
  parse(request: NtfMgr.NotificationRequest, template: LiveSystemTemplate): ILiveExtendData {
    let nextParser = this.getNextParser();
    let time = request.content.systemLiveView?.time;
    // 无计时类数据
    if (CommonUtils.isInvalid(time)) {
      return nextParser?.parse(request, template);
    }
    let liveTimerData: LiveTimerData = new LiveTimerData();
    log.showWarn(`initialTime: ${time?.initialTime}, isCountDown: ${time?.isCountDown}, isPaused: ${time?.isPaused},
      isInTitle: ${time?.isInTitle}`);
    liveTimerData.setInitialTime(time.initialTime);
    liveTimerData.setCountDown(time.isCountDown);
    liveTimerData.setPause(time.isPaused);
    liveTimerData.setInTitle(time.isInTitle);
    template.setExtendData(LiveExtendType.TYPE_COMMON_TIMER, liveTimerData);
    return nextParser?.parse(request, template) ?? liveTimerData;
  }
}

/**
 * 系统卡片模板进度扩展类数据解析器
 */
class ProgressParser extends BaseDataParser<ILiveExtendData> {
  /**
   * 解析进度类数据
   *
   * @param request 实况请求
   * @param template LiveProgressData
   */
  parse(request: NtfMgr.NotificationRequest, template: LiveSystemTemplate): ILiveExtendData | undefined {
    let nextParser = this.getNextParser();
    let progress = request.content.systemLiveView?.progress;
    // 无进度类数据
    if (CommonUtils.isInvalid(progress)) {
      return nextParser?.parse(request, template);
    }
    let liveProgressData: LiveProgressData = new LiveProgressData();
    liveProgressData.setMaxValue(progress.maxValue);
    liveProgressData.setCurrentValue(progress.currentValue);
    liveProgressData.setPercentage(progress.isPercentage);
    log.showInfo('parseProgress:' + liveProgressData.toString());
    template.setExtendData(LiveExtendType.TYPE_COMMON_PROGRESS, liveProgressData);
    return nextParser?.parse(request, template) ?? liveProgressData;
  }
}

/**
 * 系统卡片模板按钮类扩展类数据解析器
 */
class ButtonParser extends BaseDataParser<ILiveExtendData> {
  /**
   * 解析按钮类数据
   * 按钮类数据与进度类、计时器类数据不互斥
   *
   * @param request 实况请求
   * @param template LiveProgressData
   */
  parse(request: NtfMgr.NotificationRequest, template: LiveSystemTemplate): ILiveExtendData | undefined {
    let nextParser: BaseDataParser<ILiveExtendData> = this.getNextParser();
    let button = request.content.systemLiveView?.button;
    // 无按钮数据
    if (CommonUtils.isInvalid(button)) {
      return nextParser?.parse(request, template);
    }
    let icons: Array<image.PixelMap> = button.icons;
    let names: Array<string> = button.names;
    let iconResource: Array<Resource> = Reflect.get(button, 'iconsResource');
    let checkIcons = iconResource?.length > 0 ? iconResource : icons;
    // 传入的数据无效
    if (this.isButtonDataInvalid(names, checkIcons)) {
      return nextParser?.parse(request, template);
    }
    let liveButtonArray = new LiveButtonArray();
    liveButtonArray.setButtonArray(names, icons, iconResource, request);
    log.showInfo(`parsed liveButtonArray: ${liveButtonArray.toString()}`);
    template.setExtendData(LiveExtendType.TYPE_COMMON_BUTTON, liveButtonArray);
    return nextParser?.parse(request, template) ?? liveButtonArray;
  }

  /**
   * 检查按钮数据是否有效
   *
   * @param names 按钮名字数据
   * @param iconResource 图标资源数据
   * @returns 检查结果
   */
  private isButtonDataInvalid(names: Array<string>,
    iconResource: Array<Resource | image.PixelMap>): boolean {
    if (!iconResource || !names) {
      return true;
    }
    if (iconResource?.length <= 0 || iconResource?.length !== names?.length) {
      return true;
    }
    return false;
  }
}