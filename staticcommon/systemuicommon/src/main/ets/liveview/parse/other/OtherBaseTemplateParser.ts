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
import { LiveOtherExtendData } from '../../data/extend/LiveOtherExtendData';
import type NtfMgr from '@ohos.notificationManager';
import { OtherBaseTemplate } from '../../data/template/OtherBaseTemplate';
import parseUtils from '../utils/ParseUtils';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/commonconstants';
import { LiveExtendType } from '../../common/LiveConstants';
import type image from '@ohos.multimedia.image';
import transResToPicHelper from '../utils/TransResToPicHelper';
import { Parse } from '../interface/Parse';
import { LiveTimerData } from '../../data/extend/LiveTimerData';
import { SystemUICommonUtil } from '../../../utils/SystemUICommonUtil';
import { NotificationAction } from '../../../model/NotificationContent';
import notificationManager from '@ohos.notificationManager';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'OtherBaseTemplateParser';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

interface NotificationExtendInfo extends Record<string, ESObject>{
  notification_collaboration_app_name?: string;
  notification_collaboration_app_label?: string;
  notification_collaboration_app_index?: number;
  notification_collaboration_flag?: boolean;
  autoServiceInstallStatus?: number;
  appName?: string;
}

interface NotificationRequest extends notificationManager.NotificationRequest {
  extendInfo?: NotificationExtendInfo;
}

interface EventControl {
  /**
   * 锁屏沉浸态权益
   */
  lockScreen?: number;
  /**
   * 关联服务按钮权益
   */
  serviceButton?: number;
}

/**
 * 固定区内容,数组中所有对象的text字段字符串长度总和需小于1024
 */
const contentMaxLen: number = 1024;

/**
 * 解析三方卡片模板基本信息
 */
export class OtherBaseTemplateParser implements Parse<OtherBaseTemplate> {
  /**
   * 解析模板数据
   *
   * @param request 实况请求
   * @returns 模板数据
   */
  parse(request: NtfMgr.NotificationRequest): OtherBaseTemplate {
    let data = new OtherBaseTemplate();
    // 解析公有数据
    this.parseCommonData(request, data);
    return data;
  }

  /**
   * 解析解析三方卡片模板公有数据
   *
   * @param request
   * @param data
   */
  protected parseCommonData(request: NtfMgr.NotificationRequest, data: OtherBaseTemplate): void {
    let extraInfo = request.content.liveView.extraInfo;
    data.setLayoutType(extraInfo['LayoutData.layoutType'] as number);
    data.setStyle(extraInfo['LayoutData.style'] as number);
    data.setTitle(extraInfo['PrimaryData.title'] as string);
    data.setWantAgent(request?.wantAgent);
    data.setLiveEvent(extraInfo.event as string);
    let richTextArr = parseUtils.parseRichText(extraInfo['PrimaryData.content'] as string, contentMaxLen);
    data.setRichContent(richTextArr);
    this.parseUninstallMetaServiceInfo(request, data);

    //解析辅助区数据
    let extendData: LiveOtherExtendData = this.parseExtendData(request);
    data.setExtendData(LiveExtendType.TYPE_OTHER_EXTEND, extendData);
    this.parseTime(request, data);

    const serviceButtonAuthLevel = SystemUICommonUtil.safeParseJson<EventControl>(
      extraInfo?.eventControl as string)?.serviceButton ?? -1;
    if (serviceButtonAuthLevel === -1 || !serviceButtonAuthLevel) {
      log.showInfo('not show serviceButtons, serviceButtonAuthLevel is ' + serviceButtonAuthLevel);
      return;
    }
    const isServiceButtonsDisplayed = extraInfo['LayoutData.isServiceButtonsDisplayed'] as boolean;
    if (!isServiceButtonsDisplayed) {
      log.showInfo('not show serviceButtons, isServiceButtonsDisplayed is ' + isServiceButtonsDisplayed);
      return;
    }
    log.showInfo(`serviceButton: ${serviceButtonAuthLevel} isServiceButtonsDisplayed: ${isServiceButtonsDisplayed} actionButtonLength: ${request?.actionButtons?.length}`);
    // actionButtons第1、2位存放关联服务按钮want，对应serviceButtons第0、1位
    if (request?.actionButtons?.length) {
      let i = request.actionButtons.length - 1;
      let list: Array<NotificationAction> = [];
      for (; i > 0; i--) {
        list[i-1] = new NotificationAction({
          title: request.actionButtons[i]?.title,
          wantAgent: request.actionButtons[i]?.wantAgent ?? request?.wantAgent,
        });
      }
      data.setServiceButtons(list);
    }
  }

  private parseUninstallMetaServiceInfo(request: NotificationRequest, data: OtherBaseTemplate): void{
    const req = request as NotificationRequest;
    if (req?.extendInfo && req.extendInfo.autoServiceInstallStatus !== undefined) {
      data.setUninstallMetaSer(req.extendInfo.autoServiceInstallStatus);
      data.setUninstallMetaSerBoundName(req.extendInfo.appName);
    }
  }

  /**
   * 将图片对象设置到目标类的属性中
   *
   * @param obj 目标类
   * @param propertyKey 属性名
   * @param images parser中已经解析好的图片对象
   */
  protected setImageFromParser(obj: object, propertyKey: string, images?: image.PixelMap[]): void {
    // 前置图片解析时没有对应图片字段传入
    if (ArrayUtils.isEmpty(images)) {
      log.showInfo(`setPicFromParser, no image provided for '${propertyKey}'`);
      return;
    }
    // 如果图片无效则值为undefined，更新时清空图片展示为空白
    let clearImgForUpdateKey = 'clearImgForUpdate';
    obj[clearImgForUpdateKey][propertyKey] = CommonUtils.isInvalid(images[0]);
    if (obj[clearImgForUpdateKey][propertyKey]) {
      log.showInfo(`image '${propertyKey}' is invalid`);
    }
    obj[propertyKey]?.release();
    obj[propertyKey] = images[0];
  }

  /**
   * 解析辅助区数据
   *
   * @param request 实况请求
   */
  private parseExtendData(request: NtfMgr.NotificationRequest): LiveOtherExtendData {
    let extraInfo = request.content.liveView.extraInfo;
    let data: LiveOtherExtendData = new LiveOtherExtendData();
    data.setText(extraInfo['ExtendData.text'] as string);
    data.setType(extraInfo['ExtendData.type'] as number);
    let icons: Array<image.PixelMap> = request?.content?.liveView?.pictureInfo?.['ExtendData.pic'];
    if (!CommonUtils.isInvalid(icons) && icons.length > 0) {
      data.setPic(icons[0]);
    }

    const iconUpdateKey = extraInfo.ExtraInfoUpdateKey as Array<string>;
    log.info('extraInfoUpdateKey is: ', iconUpdateKey);
    if (transResToPicHelper.needParsePic(iconUpdateKey, 'ExtendData.pic.res')) {
      data.setPicRes(extraInfo['ExtendData.pic.res'] as string);
      const images: image.PixelMap[] = extraInfo.liveImages?.['ExtendData.pic.res'];
      this.setImageFromParser(data, 'pic', images);
    }
    let actionButtons: Array<NtfMgr.NotificationActionButton> | undefined = request?.actionButtons;
    if (CommonUtils.isInvalid(actionButtons) || actionButtons.length <= 0) {
      data.setWantAgent(request?.wantAgent);
      return data;
    }
    data.setWantAgent(actionButtons[0].wantAgent);
    return data;
  }

  /**
   * 解析计时模板
   *
   * @param extraInfo 实况请求
   * @param template LiveCapsuleData
   */
  private parseTime(request: NtfMgr.NotificationRequest, data: OtherBaseTemplate): void {
    let extraInfo = request.content.liveView.extraInfo;
    let time = extraInfo['LiveViewTimer.time'];
    let isUpdateTimer = extraInfo['LiveViewTimer.isUpdateTimer'] as boolean;
    let liveTimerData: LiveTimerData = new LiveTimerData();
    liveTimerData.setIsUpdateTimer(isUpdateTimer);
    if (isUpdateTimer) {
      liveTimerData.setInitialTime(Number(time));
    }
    if (!CommonUtils.isInvalid(time)) {
      data.setIsTimeTemplate(true);
    } else {
      data.setIsTimeTemplate(false);
    }
    liveTimerData.setCountDown(extraInfo['LiveViewTimer.isCountdown'] as boolean);
    liveTimerData.setPause(extraInfo['LiveViewTimer.isPaused'] as boolean);
    data.updateLiveTimer(liveTimerData);
  }
}