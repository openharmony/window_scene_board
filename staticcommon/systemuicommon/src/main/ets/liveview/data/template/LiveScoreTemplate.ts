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
import { LiveIconName, LiveType } from '../../common/LiveConstants';
import type { RichText } from './LiveBaseTemplate';
import { OtherBaseTemplate } from './OtherBaseTemplate';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'LiveScoreTemplate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 实况卡片模板，赛事类型模板
 */
@Observed
export class LiveScoreTemplate extends OtherBaseTemplate {
  /**
   * 扩展区左侧名称
   */
  hostName?: string;

  /**
   * 扩展区左侧图标
   */
  hostIcon?: image.PixelMap;

  /**
   * 扩展区左侧图标资源路径
   */
  hostIconRes?: string;

  /**
   * 扩展区左侧比分
   */
  hostScore?: string;

  /**
   * 扩展区右侧名称
   */
  guestName?: string;

  /**
   * 扩展区右侧图标
   */
  guestIcon?: image.PixelMap;

  /**
   * 扩展区右侧图标本地资源路径
   */
  guestIconRes?: string;

  /**
   * 扩展区右侧比分
   */
  guestScore?: string;

  /**
   * 扩展区中间上方描述文本
   */
  competitionDesc?: RichText[];

  /**
   * 扩展区中间下方比赛时间
   */
  competitionTime?: string;

  /**
   * 是否显示扩展区分割线
   */
  isDisplayHorizontalLine?: boolean = true;

  /**
   * 复写接口ILiveTemplateData
   *
   * @returns 实况类型
   */
  getLiveType(): LiveType {
    return LiveType.SCORE;
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    super.update(other, forceRefresh);
    if (!(other instanceof LiveScoreTemplate)) {
      return;
    }
    let otherTemplate = other as LiveScoreTemplate;
    this.setHostName(otherTemplate.hostName, forceRefresh);
    this.setHostIcon(otherTemplate.hostIcon, forceRefresh || otherTemplate.clearImgForUpdate[LiveIconName.HOST_ICON_NAME]);
    this.setHostIconRes(otherTemplate.hostIconRes, forceRefresh);
    this.setHostScore(otherTemplate.hostScore, forceRefresh);
    this.setGuestName(otherTemplate.guestName, forceRefresh);
    this.setGuestIcon(otherTemplate.guestIcon, forceRefresh || otherTemplate.clearImgForUpdate[LiveIconName.GUEST_ICON_NAME]);
    this.setGuestIconRes(otherTemplate.guestIconRes, forceRefresh);
    this.setGuestScore(otherTemplate.guestScore, forceRefresh);
    this.setCompetitionDesc(otherTemplate.competitionDesc, forceRefresh);
    this.setCompetitionTime(otherTemplate.competitionTime, forceRefresh);
    this.setDisplayHorizontalLine(otherTemplate.isDisplayHorizontalLine, forceRefresh);
  }

  /**
   * 设置扩展区左侧名称
   *
   * @param hostName 扩展区左侧名称
   * @param forceRefresh 是否强制刷新
   */
  setHostName(hostName?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(hostName)) {
      this.hostName = hostName;
    }
  }

  /**
   * 设置扩展区左侧图标
   *
   * @param hostIcon 扩展区左侧图标
   * @param forceRefresh 是否强制刷新
   */
  setHostIcon(hostIcon?: image.PixelMap, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(hostIcon)) {
      if (this.hostIcon === hostIcon) {
        return;
      }
      this.hostIcon?.release();
      this.hostIcon = hostIcon;
    }
  }

  /**
   * 设置扩展区左侧图标本地资源路径
   *
   * @param hostIconRes 扩展区左侧图标本地资源路径
   * @param forceRefresh 是否强制刷新
   */
  setHostIconRes(hostIconRes?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(hostIconRes)) {
      this.hostIconRes = hostIconRes;
    }
  }

  /**
   * 设置扩展区左侧比分
   *
   * @param hostScore 扩展区左侧比分
   * @param forceRefresh 是否强制刷新
   */
  setHostScore(hostScore?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(hostScore)) {
      this.hostScore = hostScore;
    }
  }

  /**
   * 设置扩展区右侧名称
   *
   * @param guestName 扩展区右侧名称
   * @param forceRefresh 是否强制刷新
   */
  setGuestName(guestName?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(guestName)) {
      this.guestName = guestName;
    }
  }

  /**
   * 设置扩展区右侧图标
   *
   * @param guestIcon 扩展区右侧图标本地资源路径
   * @param forceRefresh 是否强制刷新
   */
  setGuestIcon(guestIcon?: image.PixelMap, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(guestIcon)) {
      if (this.guestIcon === guestIcon) {
        return;
      }
      this.guestIcon?.release();
      this.guestIcon = guestIcon;
    }
  }

  /**
   * 设置扩展区右侧图标本地资源路径
   *
   * @param guestIconRes 扩展区右侧图标本地资源路径
   * @param forceRefresh 是否强制刷新
   */
  setGuestIconRes(guestIconRes?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(guestIconRes)) {
      this.guestIconRes = guestIconRes;
    }
  }

  /**
   * 设置扩展区右侧比分
   *
   * @param guestScore 扩展区右侧比分
   * @param forceRefresh 是否强制刷新
   */
  setGuestScore(guestScore?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(guestScore)) {
      this.guestScore = guestScore;
    }
  }

  /**
   * 设置扩展区中间上方描述文本，比赛介绍
   *
   * @param competitionDesc 扩展区中间上方描述文本
   * @param forceRefresh 是否强制刷新
   */
  setCompetitionDesc(competitionDesc?: RichText[], forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(competitionDesc)) {
      this.competitionDesc = competitionDesc;
    }
  }

  /**
   * 设置扩展区中间下方比赛时间
   *
   * @param competitionTime 扩展区中间下方比赛时间
   * @param forceRefresh 是否强制刷新
   */
  setCompetitionTime(competitionTime?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(competitionTime)) {
      this.competitionTime = competitionTime;
    }
  }

  /**
   * 设置是否显示扩展区分割线
   *
   * @param isDisplayHorizontalLine 是否显示扩展区分割线
   * @param forceRefresh 是否强制刷新
   */
  setDisplayHorizontalLine(isDisplayHorizontalLine?: boolean, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(isDisplayHorizontalLine)) {
      this.isDisplayHorizontalLine = isDisplayHorizontalLine;
    }
  }

  /**
   * 释放PixelMap对象
   */
  releaseImages(): void {
    super.releaseImages();
    if (this.hostIconRes) {
      log.showInfo('release hostIcon');
      this.hostIcon?.release();
    }
    if (this.guestIconRes) {
      log.showInfo('release guestIcon');
      this.guestIcon?.release();
    }
  }
}