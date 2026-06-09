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
import type { WantAgent } from '@ohos.wantAgent';
import type image from '@ohos.multimedia.image';
import { BaseExtendProperty } from '../../../base/common/info/BaseExtendProperty';
import { LiveExtendType,
  LiveIconName,
  LiveViewCommonConstants, OtherFormExtendShowType } from '../../common/LiveConstants';
import type { ILiveExtendData } from '../../common/ILiveExtendData';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';

export interface HandleClickAction {
  id: number;
  packageName: string;
  templateType: number;
  areaType: number;
  handleExtendClick: (data?: LiveOtherExtendData, clickCount?: number, notificationType?: number, uid?: number) => void;
}

const TAG = 'LiveOtherExtendData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
// 扩展区显示类型数组
const SHOW_EXTEND_TYPE: OtherFormExtendShowType[] = [OtherFormExtendShowType.NORMAL_TEXT,
  OtherFormExtendShowType.CAPSULE_TEXT,
  OtherFormExtendShowType.PICTURE,
  OtherFormExtendShowType.ICON];
/**
 * 三方应用卡片辅助区数据
 */
@Observed
export class LiveOtherExtendData extends BaseExtendProperty implements ILiveExtendData {
  /**
   * 普通或胶囊文本
   */
  text?: string = '';

  /**
   * 辅助区显示类型
   */
  type?: number = OtherFormExtendShowType.NOT_SHOW;

  /**
   * 图片
   */
  pic?: image.PixelMap;

  /**
   * icon本地资源路径对象
   */
  picRes?: string;

  /**
   * 点击文本或图片的跳转动作
   */
  wantAgent?: WantAgent;

  /**
   * 卡片辅助区点击事件回调
   */
  clickAction?: HandleClickAction;

  /**
   * 更新时是否清空图片（图片资源路径错误的场景）
   */
  clearImgForUpdate: Record<LiveIconName, boolean> = {
    [LiveIconName.PIC_NAME]: false,
    [LiveIconName.DESC_PIC_NAME]: false,
    [LiveIconName.SPACE_ICON_NAME]: false,
    [LiveIconName.HOST_ICON_NAME]: false,
    [LiveIconName.GUEST_ICON_NAME]: false,
    [LiveIconName.CURRNAVDIRECTION_ICON_NAME]: false,
    [LiveIconName.INDICATOR_ICON_NAME]: false
  };

  isShowExtendArea(): boolean {
    return SHOW_EXTEND_TYPE.includes(this.type);
  }

  /**
   * 复写接口ILiveExtendData
   *
   * @returns 进度类型
   */
  getLiveExtendType(): LiveExtendType {
    return LiveExtendType.TYPE_OTHER_EXTEND;
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    if (!(other instanceof LiveOtherExtendData)) {
      return;
    }
    let otherExtend = other as LiveOtherExtendData;
    this.setText(otherExtend.text, forceRefresh);
    this.setType(otherExtend.type);
    this.setPic(otherExtend.pic, forceRefresh || otherExtend.clearImgForUpdate[LiveIconName.PIC_NAME]);
    this.setPicRes(otherExtend.picRes);
    this.setWantAgent(otherExtend.wantAgent);
    this.setClickAction(otherExtend.clickAction);
  }

  /**
   * 设置文本内容
   *
   * @param text 文本内容
   * @param forceRefresh 是否强制刷新
   */
  setText(text?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(text)) {
      this.text = text;
    }
  }

  /**
   * 设置显示类型
   *
   * @param type 类型
   * @param forceRefresh 是否强制刷新
   */
  setType(type?: number, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(type)) {
      this.type = type;
    }
  }

  /**
   * 设置图片
   *
   * @param pic 图片
   * @param forceRefresh 是否强制刷新
   */
  setPic(pic?: image.PixelMap, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(pic)) {
      if (this.pic === pic) {
        log.showInfo(`the same extend pic`);
        return;
      }
      this.pic?.release();
      this.pic = pic;
    }
  }

  /**
   * 设置icon本地资源路径对象
   *
   * @param picRes 图片资源路径
   * @param forceRefresh 是否强制刷新
   */
  setPicRes(picRes?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(picRes)) {
      this.picRes = picRes;
    }
  }

  /**
   * 设置击文本或图片的跳转动作
   *
   * @param wantAgent 跳转动作
   * @param forceRefresh 是否强制刷新
   */
  setWantAgent(wantAgent?: WantAgent, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(wantAgent)) {
      this.wantAgent = wantAgent;
    }
  }

  /**
   * 设置三方应用卡片辅助区点击回调
   *
   * @param clickAction 回调函数
   * @param forceRefresh 是否强制刷新
   */
  setClickAction(clickAction: HandleClickAction, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(clickAction)) {
      this.clickAction = clickAction;
    }
  }

  /**
   * 释放PixelMap对象
   */
  releaseImages(): void {
    if (this.picRes) {
      log.showInfo('release extend pic');
      this.pic?.release();
    }
  }
}