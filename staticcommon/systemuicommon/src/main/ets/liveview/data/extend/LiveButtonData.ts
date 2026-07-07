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
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveExtendType } from '../../common/LiveConstants';
import type { ILiveExtendData } from '../../common/ILiveExtendData';
import { BaseExtendProperty } from '../../../base/common/info/BaseExtendProperty';
import ntfManager from '@ohos.notificationManager';
import { LiveViewData } from '../LiveViewData';
import { IconResource } from '../IconResource';
import { SystemUICommonUtil } from '../../../utils/SystemUICommonUtil';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'LiveButtonData');

export interface HandleButtonClick {
  (buttonData: LiveButtonData, liveViewData: LiveViewData): void;
}

let iconId = 0;

function getIconKey(): string {
  if (iconId === Number.MAX_SAFE_INTEGER) {
    iconId = 0;
  }
  return String(iconId++);
}

// 按钮优先级字段
const hw_button_priority: string = 'hw_button_priority';

/**
 * 实况卡片扩展数据，按钮信息
 */
@Observed
export class LiveButtonData extends BaseExtendProperty {
  hashCode?: string;

  /**
   * 按钮标题
   * 点击按钮时回调应用该标题
   */
  name: string = '';

  /**
   * 按钮图标
   */
  icon?: image.PixelMap;

  /**
   * 浅色模式按钮图标
   */
  lightIcon?: image.PixelMap;
  /**
   * 深色模式按钮图标
   */
  darkIcon?: image.PixelMap;

  iconResource?: IconResource;

  /**
   * 按钮图标的key
   */
  iconKey?: string;

  /**
   * 按钮点击回调
   */
  clickAction?: HandleButtonClick = (): void => {};

  /**
   * 通知id
   */
  id: number = 0;

  /**
   * 按钮对应的拉起信息
   */
  bundle: ntfManager.BundleOption;

  /**
   * 无障碍播报内容
   */
  accessibilityText: string = '';

  /**
   * 按钮状态
   */
  buttonState?: string = '';

  /**
   * 设置按钮无障碍文案
   *
   * @param text 无障碍文案
   * @param forceRefresh 是否强制刷新
   */
  setAccessibilityText(text?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(text)) {
      this.accessibilityText = text;
    }
  }

  setIconResource(iconResource: Resource): void {
    if (!iconResource) {
      return;
    }
    this.iconResource = IconResource.get(iconResource, this.hashCode);
  }

  updateIconResource(iconRes?: IconResource): void {
    if (!iconRes) {
      log.showInfo(`updateIconResource null`);
      return;
    }

    // 删除原绑定图标的更新器 (不delete CallUI代理场景多个按钮深浅色切换顺序会混乱)
    this.iconResource?.updater?.delete(this.hashCode);
    this.iconResource = iconRes;
    this.iconResource.updater?.set(this.hashCode, (icon) => {
      this.setButtonIcon(icon);
    });
  }

  /*
   * 获取按钮图标
   *
   * @param icon 按钮图标
   */
  getButtonIcon(): image.PixelMap {
    if (CommonUtils.isInvalid(this.icon) || !this.icon?.getPixelBytesNumber()) {
      log.showWarn(`invalid icon, id: ${this.id}, name: ${this.name}, key: ${this.iconKey}`);
    }
    return this.icon;
  }

  /**
   * 设置按钮状态
   *
   * @param state 按钮on/off状态
   * @param forceRefresh 是否强制刷新
   */
  setButtonState(state?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(state)) {
      this.buttonState = state;
    }
  }

  /**
   * 设置按钮标题
   *
   * @param name 按钮标题
   * @param forceRefresh 是否强制刷新
   */
  setButtonName(name?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(name)) {
      this.name = name;
    }
  }

  /**
   * 设置按钮图标
   *
   * @param icon 按钮图标
   * @param forceRefresh 是否强制刷新
   */
  setButtonIcon(icon?: image.PixelMap, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(icon)) {
      if (!this.iconResource?.icon || forceRefresh) {
        if (this.isSameIcon(this.icon, icon)) {
          return;
        }
        if (!this.isSameIcon(this.icon, this.darkIcon) && !this.isSameIcon(this.icon, this.lightIcon)) {
          log.showInfo(`icon release start`);
          SystemUICommonUtil.releaseImage(this.icon);
        }
      }
      this.icon = icon;
      this.iconKey = getIconKey();
    }
  }

  private isSameIcon(icon?: image.PixelMap, newIcon?: image.PixelMap): boolean {
    return icon === newIcon;
  }

  /**
   * 设置按钮点击回调
   *
   * @param clickAction 回调函数
   * @param forceRefresh 是否强制刷新
   */
  setClickAction(clickAction: HandleButtonClick, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(clickAction)) {
      this.clickAction = clickAction;
    }
  }

  /**
   * 设置通知id
   *
   * @param id 通知id
   * @param forceRefresh 是否强制刷新
   */
  setId(id: number, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(id)) {
      this.id = id;
    }
  }

  /**
   * 设置创建通知应用包名
   *
   * @param bundle 创建通知应用包名
   * @param forceRefresh 是否强制刷新
   */
  setBundle(bundle: ntfManager.BundleOption): void {
    this.bundle = bundle;
  }

  toString(): string {
    return `LiveButtonData{name: ${this.name}, key: ${this.iconKey}, bytes: ${this.icon?.getPixelBytesNumber()}}`;
  }
}

/**
 * 列表最多允许3个按钮
 */
const MAX_COUNT = 3;

/**
 * 实况卡片按钮集
 */
@Observed
export class LiveButtonArray extends Array<LiveButtonData> implements ILiveExtendData {
  /**
   * 按钮数组优先级
   */
  buttonPriority?: number[];

  /**
   * 按钮无障碍播报内容
   */
  private buttonAccessibilityText?: string[];

  /**
   * 按钮on/off状态，空值表示非on/off按钮，如：action按钮
   */
  private buttonOnOffState?: string[];

  /**
   * 复写接口ILiveExtendData
   *
   * @returns 按钮类型
   */
  getLiveExtendType(): LiveExtendType {
    return LiveExtendType.TYPE_COMMON_BUTTON;
  }

  /**
   * 得到胶囊数量
   *
   * @param count 按钮数量
   * @returns 按钮数组
   */
  getButtonDataByPriority(count: number = MAX_COUNT): LiveButtonArray {
    if (ArrayUtils.isEmpty(this.buttonPriority) || count >= this.length) {
      return this.slice(0, count) as LiveButtonArray;
    }
    let res: LiveButtonArray = new LiveButtonArray();
    for (let index = 0; index < count; index++) {
      res[index] = this[this.buttonPriority[index]];
    }
    return res;
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    if (!(other instanceof LiveButtonArray)) {
      return;
    }

    // 强制刷新
    if (forceRefresh) {
      this.forEach((buttonData) => {
        buttonData?.icon?.release();
      });
      ArrayUtils.clearArr(this);
    }
    let otherArray = other as LiveButtonArray;

    // 更新按钮集
    this.updateButtonArray(otherArray?.length ?? 0, (index): LiveButtonData => {
      return ArrayUtils.findArr(otherArray, index);
    });
    this.buttonPriority = other.buttonPriority;
    this.buttonAccessibilityText = other.buttonAccessibilityText;
    this.buttonOnOffState = other.buttonOnOffState;
  }

  /**
   * 设置按钮集
   *
   * @param names 按钮标题集
   * @param icons 按钮图标集
   */
  setButtonArray(names: Array<string>, icons: Array<image.PixelMap>, iconResource: Array<Resource>,
    request: ntfManager.NotificationRequest): void {
    this.buttonPriority = request.extraInfo?.hw_button_priority;
    this.buttonAccessibilityText = request.extraInfo?.hw_button_accessibility_text;
    this.buttonOnOffState = request.extraInfo?.hw_button_state_on; // 应用接入button on/off状态
    this.updateButtonArray(request.content.systemLiveView?.progress ? MAX_COUNT - 1 : MAX_COUNT,
      (index): LiveButtonData => {
      let name = ArrayUtils.findArr(names, index);
      let icon = ArrayUtils.findArr(icons, index);
      let iconRes = ArrayUtils.findArr(iconResource, index);

      // 无对应标题及图标，则终止
      if (CommonUtils.isInvalid(name) && CommonUtils.isInvalid(icon)) {
        return null;
      }
      let button = new LiveButtonData();
      button.hashCode = request.hashCode;
      button.name = name;
      button.icon = icon;
      button.setIconResource(iconRes);
      button.id = request.id;
      button.bundle = Reflect.get(request, 'agentBundle') ?? {
        bundle: request.creatorBundleName,
        uid: request.creatorUid,
      };
      button.accessibilityText = this.buttonAccessibilityText?.[index] ?? '';
      button.buttonState = this.buttonOnOffState?.[index] ?? '';
      return button;
    });
  }

  /**
   * 设置按钮集
   *
   * @param icons 按钮图标集
   */
  setButtonArrayByIcons(icons: Array<image.PixelMap>): void {
    this.updateButtonArray(icons?.length ?? 0, (index): LiveButtonData => {
      let icon = ArrayUtils.findArr(icons, index);
      let button = new LiveButtonData();

      if (CommonUtils.isInvalid(icon)) {
        button.icon = undefined;
      } else {
        button.icon = icon;
      }
      return button;
    });
  }

  toString(): string {
    let tmp: string = '';
    this.forEach((value, index) => {
      tmp += value.toString() + ', ';
    });
    return 'LiveButtonArray{' + tmp + '}';
  }

  /**
   * 更新按钮集
   *
   * @param request 请求对应索引更新数据源
   */
  private updateButtonArray(maxCount: number, request: (index: number) => LiveButtonData | null): void {
    // 记录按钮个数
    let count = 0;
    for (let i = 0; i < maxCount; i++) {
      // 更新按钮来源
      let otherButton = request?.(i);
      if (CommonUtils.isInvalid(otherButton)) {
        break;
      }

      // 记录按钮个数
      count++;

      // 优先按钮复用
      let button = ArrayUtils.findArr(this, i);
      if (CommonUtils.isInvalid(button)) {
        button = new LiveButtonData();
        this.push(button);
      } else if (CommonUtils.isInvalid(otherButton.icon)) {
        log.showInfo(`updateButtonArray release icon`);
        button.icon?.release();
        button.icon = undefined;
        button.iconKey = undefined;
      }
      button.hashCode = otherButton.hashCode;
      button.setButtonName(otherButton.name);
      button.setAccessibilityText(otherButton.accessibilityText);
      button.setButtonState(otherButton?.buttonState);
      button.lightIcon = otherButton?.lightIcon;
      button.darkIcon = otherButton?.darkIcon;
      button.setButtonIcon(otherButton.icon);
      button.updateIconResource(otherButton.iconResource);
      button.setClickAction(otherButton.clickAction);
      button.setId(otherButton.id);
      button.setBundle(otherButton.bundle);
    }

    // 存在多余按钮，清除
    let len = this.length;
    if (count < len) {
      for (let index = count; index < len; ++index) {
        if (!this[index]?.iconResource?.icon) {
          log.showInfo(`updateButtonArray release icon`);
          this[index]?.icon?.release();
        }
      }
      this.splice(count, len - count);
    }
  }

  /**
   * 释放PixelMap对象
   */
  releaseImages(): void {
    this.forEach(buttonIcon => buttonIcon.icon?.release());
  }
}