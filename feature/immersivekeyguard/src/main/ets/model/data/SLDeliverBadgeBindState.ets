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

import { WidgetBindState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { DeliverBadgeBindType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';

/**
 * 锁屏组件，克隆应用角标组件UI绑定状态
 *
 */
@Observed
export class SLDeliverBadgeBindState extends WidgetBindState<DeliverBadgeBindType> {
  /**
   * 克隆应用图标根组件宽度
   */
  @Track private badgeRootWidth?: number;
  /**
   * 克隆应用图标根组件高度
   */
  @Track private badgeRootHeight?: number;
  /**
   * 克隆应用图标宽度
   */
  @Track private badgeIconWidth?: number;
  /**
   * 克隆应用图标高度
   */
  @Track private badgeIconHeight?: number;
  /**
   * 克隆应用图标背板左上，右下圆角大小
   */
  @Track private badgeColumnLeftRadius?: number;
  /**
   * 克隆应用图标背板右上，左下圆角大小
   */
  @Track private badgeColumnRightRadius?: number;
  /**
   * 克隆应用图标根组件右侧偏移量
   */
  @Track private rootROffset?: number;
  /**
   * 克隆应用图标根组件底部偏移量
   */
  @Track private rootBOffset?: number;
  /**
   * 克隆应用角标背板默认透明度
   */
  @Track private opacity?: number;
  /**
   * 克隆应用图标svg填充色
   */
  @Track private badgeFillColor?: ResourceColor;

  constructor() {
    super(SlMainStateType.SL_DELIVER_BADGE_BIND_STATE);
  }

  /**
   * 复写WidgetBindState
   *
   */
  protected initSetMethods(): void {
    super.initSetMethods();
    this.setMethods.set(DeliverBadgeBindType.BADGE_ROOT_WIDTH, this.setMethodBadgeRootWidth);
    this.setMethods.set(DeliverBadgeBindType.BADGE_ROOT_HEIGHT, this.setMethodBadgeRootHeight);
    this.setMethods.set(DeliverBadgeBindType.BADGE_ICON_WIDTH, this.setMethodBadgeIconWidth);
    this.setMethods.set(DeliverBadgeBindType.BADGE_ICON_HEIGHT, this.setMethodBadgeIconHeight);
    this.setMethods.set(DeliverBadgeBindType.BADGE_COLUMN_LEFT_RADIUS, this.setMethodBadgeColumnLeftRadius);
    this.setMethods.set(DeliverBadgeBindType.BADGE_COLUMN_RIGHT_RADIUS, this.setMethodBadgeColumnRightRadius);
    this.setMethods.set(DeliverBadgeBindType.ROOT_RIGHT_OFFSET, this.setMethodRootROffset);
    this.setMethods.set(DeliverBadgeBindType.ROOT_BOTTOM_OFFSET, this.setMethodRootBOffset);
    this.setMethods.set(DeliverBadgeBindType.OPACITY, this.setMethodOpacity);
    this.setMethods.set(DeliverBadgeBindType.BADGE_FILL_COLOR, this.setMethodBadgeFillColor);
  }

  private setMethodBadgeRootWidth(st: SLDeliverBadgeBindState, value: number): void {
    st.setBadgeRootWidth(value);
  }

  private setMethodBadgeRootHeight(st: SLDeliverBadgeBindState, value: number): void {
    st.setBadgeRootHeight(value);
  }

  private setMethodBadgeIconWidth(st: SLDeliverBadgeBindState, value: number): void {
    st.setBadgeIconWidth(value);
  }

  private setMethodBadgeIconHeight(st: SLDeliverBadgeBindState, value: number): void {
    st.setBadgeIconHeight(value);
  }

  private setMethodBadgeColumnLeftRadius(st: SLDeliverBadgeBindState, value: number): void {
    st.setBadgeColumnLeftRadius(value);
  }

  private setMethodBadgeColumnRightRadius(st: SLDeliverBadgeBindState, value: number): void {
    st.setBadgeColumnRightRadius(value);
  }

  private setMethodRootROffset(st: SLDeliverBadgeBindState, value: number): void {
    st.setRootROffset(value);
  }

  private setMethodRootBOffset(st: SLDeliverBadgeBindState, value: number): void {
    st.setRootBOffset(value);
  }

  private setMethodOpacity(st: SLDeliverBadgeBindState, value: number): void {
    st.setOpacity(value);
  }

  private setMethodBadgeFillColor(st: SLDeliverBadgeBindState, value: number): void {
    st.setBadgeFillColor(value);
  }

  private getMethodBadgeRootWidth(st: SLDeliverBadgeBindState): number | undefined {
    return st.getBadgeRootWidth();
  }

  private getMethodBadgeRootHeight(st: SLDeliverBadgeBindState): number | undefined {
    return st.getBadgeRootHeight();
  }

  private getMethodBadgeIconWidth(st: SLDeliverBadgeBindState): number | undefined {
    return st.getBadgeIconWidth();
  }

  private getMethodBadgeIconHeight(st: SLDeliverBadgeBindState): number | undefined {
    return st.getBadgeIconHeight();
  }

  private getMethodBadgeColumnLeftRadius(st: SLDeliverBadgeBindState): number | undefined {
    return st.getBadgeColumnLeftRadius();
  }

  private getMethodBadgeColumnRightRadius(st: SLDeliverBadgeBindState): number | undefined {
    return st.getBadgeColumnRightRadius();
  }

  private getMethodRootROffset(st: SLDeliverBadgeBindState): number | undefined {
    return st.getRootROffset();
  }

  private getMethodRootBOffset(st: SLDeliverBadgeBindState): number | undefined {
    return st.getRootBOffset();
  }

  private getMethodOpacity(st: SLDeliverBadgeBindState): number | undefined {
    return st.getOpacity();
  }

  /**
   * 复写WidgetBindState
   *
   */
  protected initGetMethods(): void {
    super.initGetMethods();
    this.getMethods.set(DeliverBadgeBindType.BADGE_ROOT_WIDTH, this.getMethodBadgeRootWidth);
    this.getMethods.set(DeliverBadgeBindType.BADGE_ROOT_HEIGHT, this.getMethodBadgeRootHeight);
    this.getMethods.set(DeliverBadgeBindType.BADGE_ICON_WIDTH, this.getMethodBadgeIconWidth);
    this.getMethods.set(DeliverBadgeBindType.BADGE_ICON_HEIGHT, this.getMethodBadgeIconHeight);
    this.getMethods.set(DeliverBadgeBindType.BADGE_COLUMN_LEFT_RADIUS, this.getMethodBadgeColumnLeftRadius);
    this.getMethods.set(DeliverBadgeBindType.BADGE_COLUMN_RIGHT_RADIUS, this.getMethodBadgeColumnRightRadius);
    this.getMethods.set(DeliverBadgeBindType.ROOT_RIGHT_OFFSET, this.getMethodRootROffset);
    this.getMethods.set(DeliverBadgeBindType.ROOT_BOTTOM_OFFSET, this.getMethodRootBOffset);
    this.getMethods.set(DeliverBadgeBindType.OPACITY, this.getMethodOpacity);
  }

  /**
   * 设置克隆应用图标根组件宽度
   *
   */
  public setBadgeRootWidth(val: number): SLDeliverBadgeBindState {
    if (this.badgeRootWidth !== val) {
      this.badgeRootWidth = val;
      this.notifyStateChange(DeliverBadgeBindType.BADGE_ROOT_WIDTH);
    }
    return this;
  }

  /**
   * 获取克隆应用图标根组件宽度
   *
   */
  public getBadgeRootWidth(): number | undefined {
    return this.badgeRootWidth;
  }

  /**
   * 设置克隆应用图标根组件高度
   *
   */
  public setBadgeRootHeight(val: number): SLDeliverBadgeBindState {
    if (this.badgeRootHeight !== val) {
      this.badgeRootHeight = val;
      this.notifyStateChange(DeliverBadgeBindType.BADGE_ROOT_HEIGHT);
    }
    return this;
  }

  /**
   * 获取克隆应用图标根组件高度
   *
   */
  public getBadgeRootHeight(): number | undefined {
    return this.badgeRootHeight;
  }

  /**
   * 设置克隆应用图标宽度
   *
   */
  public setBadgeIconWidth(val: number): SLDeliverBadgeBindState {
    if (this.badgeIconWidth !== val) {
      this.badgeIconWidth = val;
      this.notifyStateChange(DeliverBadgeBindType.BADGE_ICON_WIDTH);
    }
    return this;
  }

  /**
   * 获取克隆应用图标宽度
   *
   */
  public getBadgeIconWidth(): number | undefined {
    return this.badgeIconWidth;
  }

  /**
   * 设置克隆应用图标高度
   *
   */
  public setBadgeIconHeight(val: number): SLDeliverBadgeBindState {
    if (this.badgeIconHeight !== val) {
      this.badgeIconHeight = val;
      this.notifyStateChange(DeliverBadgeBindType.BADGE_ICON_HEIGHT);
    }
    return this;
  }

  /**
   * 获取克隆应用图标高度
   *
   */
  public getBadgeIconHeight(): number | undefined {
    return this.badgeIconHeight;
  }

  /**
   * 设置克隆应用图标背板左上，右下圆角大小
   *
   */
  public setBadgeColumnLeftRadius(radius: number): SLDeliverBadgeBindState {
    if (this.badgeColumnLeftRadius !== radius) {
      this.badgeColumnLeftRadius = radius;
      this.notifyStateChange(DeliverBadgeBindType.BADGE_COLUMN_LEFT_RADIUS);
    }
    return this;
  }

  /**
   * 获取克隆应用图标背板左上，右下圆角大小
   *
   */
  public getBadgeColumnLeftRadius(): number | undefined {
    return this.badgeColumnLeftRadius;
  }

  /**
   * 设置克隆应用图标背板右上，左下圆角大小
   *
   */
  public setBadgeColumnRightRadius(radius: number): SLDeliverBadgeBindState {
    if (this.badgeColumnRightRadius !== radius) {
      this.badgeColumnRightRadius = radius;
      this.notifyStateChange(DeliverBadgeBindType.BADGE_COLUMN_RIGHT_RADIUS);
    }
    return this;
  }

  /**
   * 获取克隆应用图标背板右上，左下圆角大小
   *
   */
  public getBadgeColumnRightRadius(): number | undefined {
    return this.badgeColumnRightRadius;
  }

  /**
   * 设置克隆应用图标根组件右侧偏移量
   *
   */
  public setRootROffset(val: number): SLDeliverBadgeBindState {
    if (this.rootROffset !== val) {
      this.rootROffset = val;
      this.notifyStateChange(DeliverBadgeBindType.ROOT_RIGHT_OFFSET);
    }
    return this;
  }

  /**
   * 获取克隆应用图标根组件右侧偏移量
   *
   */
  public getRootROffset(): number | undefined {
    return this.rootROffset;
  }

  /**
   * 设置克隆应用图标根组件底部偏移量
   *
   */
  public setRootBOffset(val: number): SLDeliverBadgeBindState {
    if (this.rootBOffset !== val) {
      this.rootBOffset = val;
      this.notifyStateChange(DeliverBadgeBindType.ROOT_BOTTOM_OFFSET);
    }
    return this;
  }

  /**
   * 获取克隆应用图标根组件底部偏移量
   *
   */
  public getRootBOffset(): number | undefined {
    return this.rootBOffset;
  }

  /**
   * 设置克隆应用角标背板透明度
   *
   */
  public setOpacity(val: number): SLDeliverBadgeBindState {
    if (this.opacity !== val) {
      this.opacity = val;
      this.notifyStateChange(DeliverBadgeBindType.OPACITY);
    }
    return this;
  }

  /**
   * 获取克隆应用角标背板透明度
   *
   */
  public getOpacity(): number | undefined {
    return this.opacity;
  }

  /**
   * 设置克隆应用角标svg填充色
   *
   */
  public setBadgeFillColor(val: ResourceColor): SLDeliverBadgeBindState {
    if (this.badgeFillColor !== val) {
      this.badgeFillColor = val;
      this.notifyStateChange(DeliverBadgeBindType.BADGE_FILL_COLOR);
    }
    return this;
  }

  /**
   * 获取克隆应用角标svg填充色
   *
   */
  public getBadgeFillColor(): ResourceColor | undefined {
    return this.badgeFillColor;
  }
}