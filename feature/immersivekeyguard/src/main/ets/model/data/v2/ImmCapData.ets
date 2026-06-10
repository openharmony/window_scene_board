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

import { ArrayUtils, LogDomain, Logger } from '@ohos/basicutils';
import {
  LiveButtonModel,
  LiveTimerModel,
  NotificationBase
} from '@ohos/systemuicommon/newTsIndex';
import { CapShowType } from '../../../common/constants/ImmCapConst';
import { ImmersiveComHelper } from '../../../common/helper/ImmersiveComHelper';
import { ImmDataType } from '../../../common/ImmersiveConstants';
import { SlStateHelper } from '../../helper/SlStateHelper';
import { ImmBaseData } from './ImmBaseData';
import { SlCapBindStateV2 } from './SlCapBindStateV2';

const TAG = 'ImmCapData';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

// 组通知取Child索引
const SECONDARY_INDEX = 1;

// 按钮允许显示最大数
const MAX_SHOW_COUNT = 3;

/**
 * 沉浸胶囊数据结构
 */
@ObservedV2
export class ImmCapData extends ImmBaseData<ImmCapData> {
  // 胶囊显示类型
  @Trace private _capShowType: CapShowType = CapShowType.CAP_NONE;

  // 原次标题，组通知场景第二条子通知标题
  @Trace private _oriSecondaryTitle?: string;

  // 原次内容，组通知场景第二条子通知内容
  @Trace private _oriSecondaryContent?: string;

  // 是否隐藏文本中的计时器
  @Trace private _isHideTimer: boolean = false;

  // 是否需要强提醒显示
  @Trace private _isRemindShow: boolean = false;

  // 系统实况按钮优先级索引列表
  @Trace private _buttonPriority?: number[];

  // 胶囊UI绑定状态
  @Computed get capBindSt(): SlCapBindStateV2 {
    return SlStateHelper.getInstance(this._liveVmInjector?.getStateMgr()).getCapBindState();
  }

  /**
   * 标示胶囊类型
   *
   * @returns 胶囊类型
   */
  protected getImmDataType(): ImmDataType {
    return ImmDataType.DATA_CAP;
  }

  /**
   * 新实例
   *
   * @returns 新实例
   */
  protected createNewData(): ImmCapData {
    return new ImmCapData(this._oriData);
  }

  /**
   * 属性还原
   */
  protected resetProperty(): void {
    super.resetProperty();
    this._oriSecondaryTitle = undefined;
    this._oriSecondaryContent = undefined;
    this._isRemindShow = false;
    this._buttonPriority = undefined;
  }

  /**
   * 数据刷新
   *
   * @param update 原数据
   */
  public updateData(update: NotificationBase): void {
    super.updateData(update);
    // 组通知
    if (update.isNormalGroup()) {
      let secondaryData = update.children?.[SECONDARY_INDEX];
      this._oriSecondaryTitle = secondaryData?.content?.contentTitle;
      this._oriSecondaryContent = secondaryData?.content?.contentText;
    }
    // 实况通知
    if (update.isLiveView()) {
      if (update.card?.isSystemCard()) {
        this.safeBtnPriority(update.card.buttonPriority);
      }
      // 强提醒记录
      this._isRemindShow = update.isFlip() || update.isExpand();
    }
  }

  /**
   * 按钮优先级安全检测
   *
   * @param btnPriority 按钮优先级集
   */
  private safeBtnPriority(btnPriority?: number[]): void {
    // 优先级与按钮数据映射
    if (!ArrayUtils.isEmpty(btnPriority) && !ArrayUtils.isEmpty(this._sysButtons)) {
      let btnSize = ArrayUtils.getSize(this._sysButtons);
      // 提前记录需要达到的固定索引个数
      const tarIndex: Map<number, number> = new Map();
      for (let i = 0; i < btnSize; i++) {
        tarIndex.set(i, i);
      }
      // 匹配有效索引
      let resultPriority: number[] = [];
      for (let i = 0; i < btnSize; i++) {
        let priorityIndex = btnPriority?.[i] ?? -1;
        if (priorityIndex < 0 || priorityIndex >= btnSize) {
          log.showWarn(TAG, `safeBtnPriority invalid priority: ${priorityIndex}, ${btnSize}`);
          continue;
        }
        // 去重
        if (tarIndex.has(priorityIndex)) {
          resultPriority.push(priorityIndex);
          tarIndex.delete(priorityIndex);
        }
      }
      if (ArrayUtils.isEmpty(tarIndex)) {
        this._buttonPriority = resultPriority;
        return;
      }
      // 未达到固定个数，则按序补充
      for (let i = 0; i < btnSize; i++) {
        let priorityIndex = tarIndex.get(i);
        if (priorityIndex !== undefined) {
          resultPriority.push(priorityIndex);
        }
      }
      this._buttonPriority = resultPriority;
    }
  }

  /**
   * 取值主title
   *
   * @returns 主title
   */
  @Computed get mainTitle(): ResourceStr {
    // 隐私场景
    let privacyText = this.getPrivacyTitleText();
    if (privacyText) {
      return privacyText;
    }
    // 当计时器为phone类型时，AOD场景为固定文本
    let phoneText = this.getPhoneAodText();
    if (phoneText) {
      return phoneText;
    }
    // 系统实况为单计时器，无文本+计时器拼接场景
    let oriTitle = this.getTimerOriTitle();
    // 实况计时器在title上显示
    if (this.hasLiveTimer() && this._isTimerInTitle && ImmersiveComHelper.testTimeRegx(oriTitle)) {
      let timer = this._liveTimer as LiveTimerModel;
      let timeStr = this._isHideTimer ? undefined : this._liveVmInjector?.getTimerVm()?.getTimerText(timer);
      return ImmersiveComHelper.getTimeReplaceStr(oriTitle, timeStr);
    }
    // 通用场景
    return this._oriTitle ?? '';
  }

  /**
   * 取值次要title，组通知场景第二条子通知title
   *
   * @returns 次title
   */
  @Computed get secondaryTitle(): string | undefined {
    // 隐私场景，不显示
    if (this.isDataPrivacy()) {
      return undefined;
    }
    return this._oriSecondaryTitle;
  }

  /**
   * 取值主内容文本
   *
   * @returns 主内容文本
   */
  @Computed get mainContent(): ResourceStr {
    // 隐私场景
    let privacyText = this.getPrivacyContentText(this._childrenCount);
    if (privacyText) {
      return privacyText;
    }
    // 当计时器为phone类型时，AOD场景为固定文本
    let phoneText = this.getPhoneAodText();
    if (phoneText) {
      return phoneText;
    }
    // 系统实况为单计时器，无文本+计时器拼接场景
    let oriContent = this.getTimerOriContent();
    // 实况计时器在副文本显示
    if (this.hasLiveTimer() && !this._isTimerInTitle && ImmersiveComHelper.testTimeRegx(oriContent)) {
      let timer = this._liveTimer as LiveTimerModel;
      let timeStr = this._isHideTimer ? undefined : this._liveVmInjector?.getTimerVm()?.getTimerText(timer);
      return ImmersiveComHelper.getTimeReplaceStr(oriContent, timeStr);
    }
    // 通用场景
    return this._oriContent ?? '';
  }

  /**
   * 取值次要内容，组通知场景第二条子通知内容
   *
   * @returns 次内容
   */
  @Computed get secondaryContent(): string | undefined {
    // 隐私场景，不显示
    if (this.isDataPrivacy()) {
      return undefined;
    }
    return this._oriSecondaryContent;
  }

  /**
   * 按btn优先级取数据
   *
   * @returns 优先级按钮数据
   */
  @Computed get priorityBtn(): LiveButtonModel[] | undefined {
    if (!this.hasSysButton()) {
      return undefined;
    }
    // 存在进度条，则少取一个按钮
    let limitCount = this.capBindSt?.getShowBtnCount() ?? MAX_SHOW_COUNT;
    let tarCount = limitCount - (this.hasSysProgress() ? 1 : 0);
    if (tarCount <= 0) {
      return undefined;
    }
    // 无需优先级，按序取
    let btnSize = ArrayUtils.getSize(this._sysButtons);
    let validSize = Math.min(tarCount, btnSize);
    if (ArrayUtils.isEmpty(this._buttonPriority) || tarCount >= btnSize) {
      return this._sysButtons?.slice(0, validSize);
    }
    // 按优先级取
    let result: LiveButtonModel[] = [];
    for (let i = 0; i < validSize; i++) {
      let priorityIndex = this._buttonPriority?.[i] ?? 0;
      result.push(this._sysButtons?.[priorityIndex] as LiveButtonModel);
    }
    return result;
  }

  /**
   * 是否显示组通知样式
   *
   * @returns true组通知样式
   */
  public isShowGroupStyle(): boolean {
    // 隐私场景，不显示组通知样式
    if (this.isDataPrivacy()) {
      return false;
    }
    // 存在多条子通知时，显示组通知样式
    return Boolean(this._oriSecondaryTitle);
  }

  /**
   * 是否显示扩展区
   *
   * @returns true显示扩展区
   */
  public isShowExtensionArea(): boolean {
    // 隐私场景，不显示扩展区
    if (this.isDataPrivacy()) {
      return false;
    }
    return this.hasSysProgress() || this.hasSysButton() || this.hasOtherExtension();
  }

  /**
   * 是否为强提醒胶囊
   *
   * @returns true强提醒
   */
  public isRemindShow(): boolean {
    return this._isRemindShow;
  }

  /**
   * 设置当前胶囊数据显示类型
   *
   * @param type 显示类型
   */
  public setCapShowType(type: CapShowType): void {
    if (this._capShowType !== type) {
      this._capShowType = type;
    }
  }

  /**
   * 当前胶囊数据显示类型
   *
   * @returns 显示类型
   */
  public getCapShowType(): CapShowType {
    return this._capShowType;
  }
}