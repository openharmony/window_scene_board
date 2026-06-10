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
import { CommonUtils, LogDomain, LogHelper, ArrayUtils } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/commonconstants';
import type NtfMgr from '@ohos.notificationManager';
import { CapsuleDataType, CapsuleRemindType, CapsuleType, LiveViewCommonConstants } from '../../common/LiveConstants';
import { LiveCapsuleData } from '../../data/capsule/LiveCapsuleData';
import { LiveProgressData } from '../../data/extend/LiveProgressData';
import { LiveTimerData } from '../../data/extend/LiveTimerData';
import type { Parse } from '../interface/Parse';
import transResToPicHelper from '../utils/TransResToPicHelper';
import notificationManager from '@ohos.notificationManager';
import { NtfReminderConfig } from '../../../model/NtfRemindFlags';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'OtherLiveCapsuleDataParser';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const DATA_CAPSULE: Map<CapsuleDataType, CapsuleType> = new Map([
  [CapsuleDataType.CAPSULE_TYPE_TEXT, CapsuleType.TYPE_TEXT],
  [CapsuleDataType.CAPSULE_TYPE_PROGRESS, CapsuleType.TYPE_PROGRESS],
  [CapsuleDataType.CAPSULE_TYPE_TIMER, CapsuleType.TYPE_TIMER],
]);


/**
 * 解析三方应用实况胶囊数据解析器
 */
export class OtherLiveCapsuleDataParser implements Parse<LiveCapsuleData> {
  /**
   * 解析胶囊数据
   *
   * @param request 实况请求
   * @returns 胶囊数据
   */
  parse(request: NtfMgr.NotificationRequest): LiveCapsuleData | undefined {
    let extraInfo = request.content.liveView.extraInfo;
    if (CommonUtils.isInvalid(extraInfo)) {
      log.showError('extraInfo is inValid');
      return undefined;
    }
    let capsuleType: CapsuleType | undefined = this.getCapsuleType(extraInfo);
    if (CommonUtils.isInvalid(capsuleType)) {
      log.showInfo('no capsule data');
      return undefined;
    }
    let capsule: LiveCapsuleData = new LiveCapsuleData();
    capsule.setBundleName(request.creatorBundleName);
    capsule.setUid(request.creatorUid);
    capsule.setHashCode(request.hashCode);
    capsule.setCapsuleStatus(extraInfo['CapsuleData.status'] as number);
    capsule.setCapsuleType(capsuleType);

    let agentBundle: notificationManager.BundleOption =
      Reflect.get(request, 'agentBundle') as notificationManager.BundleOption;
    if (agentBundle?.bundle === LiveViewCommonConstants.PUSH_BUNDLE_NAME) {
      capsule.setCapsuleRemind(this.getCapsuleRemind(request.notificationFlags?.reminderFlags ?? 0,
        extraInfo['CapsuleData.remind'] as CapsuleRemindType));
    }
    let icons: Array<image.PixelMap> = request.content.liveView.pictureInfo?.['CapsuleData.icon'];
    if (!CommonUtils.isInvalid(icons) && icons.length > 0) {
      capsule.setCapsuleIcon(icons[0]);
    }

    const iconUpdateKey = extraInfo.ExtraInfoUpdateKey as Array<string>;
    if (transResToPicHelper.needParsePic(iconUpdateKey, 'CapsuleData.icon.res')) {
      capsule.setCapsuleIconResource(extraInfo['CapsuleData.icon.res'] as string);
      const icons: image.PixelMap[] = extraInfo.liveImages?.['CapsuleData.icon.res'];
      const iconsFallback: image.PixelMap[] = extraInfo.liveImages?.['Capsule.iconFallback'];
      if (!ArrayUtils.isEmpty(icons) && !CommonUtils.isInvalid(icons[0])) {
        capsule.setCapsuleIcon(icons[0]);
      } else if (!capsule.icon && !ArrayUtils.isEmpty(iconsFallback)) {
        capsule.setCapsuleIcon(iconsFallback[0]);
      }
    }
    capsule.setBackgroundColor(extraInfo['CapsuleData.backgroundColor'] as string);
    capsule.setIsContentDisplayed(extraInfo['CapsuleData.isContentDisplayed'] as boolean);
    this.setCapsuleContent(extraInfo, capsule);
    log.showInfo(capsule.toString());
    return capsule;
  }

  getCapsuleRemind(reminderFlags: number, remindType: CapsuleRemindType): CapsuleRemindType {
    const flag = new NtfReminderConfig(reminderFlags);
    if (flag.isBannerEnable()) {
      return CapsuleRemindType.EXPAND;
    }
    if (flag.isCapsuleFlip()) {
      return CapsuleRemindType.FLIP;
    }
    // LiveViewKit 上库后 删除
    if (remindType === CapsuleRemindType.FLIP) {
      return CapsuleRemindType.FLIP;
    }
    if (remindType === CapsuleRemindType.EXPAND) {
      return CapsuleRemindType.EXPAND;
    }
    return CapsuleRemindType.DEFAULT;
  }

  /**
   * 设置胶囊核心内容信息
   *
   * @param extraInfo 实况请求数据
   * @param capsule 胶囊
   */
  private setCapsuleContent(extraInfo: { [key: string]: Object }, capsule: LiveCapsuleData): void {
    let type = capsule.type;
    log.showInfo('parse capsule, type:' + type);
    switch (type) {
      case CapsuleType.TYPE_TEXT:
        this.parseText(extraInfo, capsule);
        break;
      case CapsuleType.TYPE_TIMER:
        this.parseTime(extraInfo, capsule);
        break;
      case CapsuleType.TYPE_PROGRESS:
        this.parseProgress(extraInfo, capsule);
        break;
      default:
        log.showWarn('setCapsuleContent data not normal');
        break;
    }
  }

  /**
   * 读取胶囊类型
   *
   * @param extraInfo 实况请求
   * @returns 读取结果
   */
  private getCapsuleType(extraInfo: { [key: string]: Object }): CapsuleType | undefined {
    return DATA_CAPSULE.get(extraInfo['CapsuleData.type'] as number);
  }

  /**
   * 解析文本类数据
   *
   * @param extraInfo 实况请求
   * @param capsule LiveCapsuleData
   */
  private parseText(extraInfo: { [key: string]: Object }, capsule: LiveCapsuleData): void {
    capsule.setCapsuleTitle(extraInfo['TextCapsule.title'] as string);
    capsule.setCapsuleExtend(extraInfo['TextCapsule.content'] as string);
  }

  /**
   * 解析进度类数据
   *
   * @param extraInfo 实况请求
   * @param template LiveCapsuleData
   */
  private parseProgress(extraInfo: { [key: string]: Object }, capsule: LiveCapsuleData): void {
    let liveProgressData: LiveProgressData = new LiveProgressData();
    liveProgressData.setMaxValue(extraInfo['ProgressCapsule.max'] as number);
    liveProgressData.setCurrentValue(extraInfo['ProgressCapsule.progress'] as number);
    liveProgressData.setPercentage(extraInfo['ProgressCapsule.indeterminate'] as boolean);
    capsule.setCapsuleTypeData(liveProgressData);
  }

  /**
   * 解析倒计时类数据
   *
   * @param extraInfo 实况请求
   * @param template LiveCapsuleData
   */
  private parseTime(extraInfo: { [key: string]: Object }, capsule: LiveCapsuleData): void {
    let liveTimerData: LiveTimerData = new LiveTimerData();
    liveTimerData.setIsUpdateTimer(extraInfo['TimerCapsule.isUpdateTimer'] as boolean);
    if (liveTimerData.isUpdateTimer) {
      log.showWarn(`parse timer capsule, setInitialTime: ${extraInfo['TimerCapsule.time']}`);
      liveTimerData.setInitialTime(Number(extraInfo['TimerCapsule.time']));
    }
    liveTimerData.setCountDown(extraInfo['TimerCapsule.isCountdown'] as boolean);
    liveTimerData.setPause(extraInfo['TimerCapsule.isPause'] as boolean);
    log.showInfo(`parse timer capsule, isCountdown: ${liveTimerData?.isCountDown}, isPause: ${liveTimerData?.isPause}`);
    capsule.setCapsuleTypeData(liveTimerData);
    capsule.setCapsuleExtend(extraInfo['TimerCapsule.content'] as string);
  }
}