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

import { LogDomain, Logger } from '@ohos/basicutils';
import { display, window } from '@kit.ArkUI';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'FormEditLayout';
const log = Logger.getLogHelper(LogDomain.FORM);

// 主屏幕ID
const DEFAULT_DISPLAY_ID = 0;

export class WindowRect implements window.Rect {
  public displayID: number = 0;
  public left: number = 0;
  public top: number = 0;
  public width: number = 0;
  public height: number = 0;

  constructor(displayID: number = 0) {
    this.displayID = displayID;
  }

  public toString(): string {
    return `{ "displayID": ${this.displayID}, "left": ${this.left}, "top": ${this.top}, "width": ${this.width}, "height": ${this.height} }`;
  }
}

export abstract class FormEditLayout {
  protected static screenRect: WindowRect = new WindowRect();

  public abstract getFormEditWidth(): number;

  public abstract getFormEditHeight(): number;

  public abstract resetParam(): void;

  public static setScreenRect(left: number, top: number, width: number, height: number): void {
    FormEditLayout.screenRect.left = left;
    FormEditLayout.screenRect.top = top;
    FormEditLayout.screenRect.width = width;
    FormEditLayout.screenRect.height = height;
  }

  /**
   * 获取卡片编辑页位置
   * @returns [left, top]
   */
  public getFormEditPosition(): number[] {
    const screen: WindowRect = new WindowRect();
    screen.width = px2vp(FormEditLayout.screenRect.width);
    screen.height = px2vp(FormEditLayout.screenRect.height);
    const formEditRect: WindowRect = new WindowRect();
    formEditRect.width = this.getFormEditWidth();
    formEditRect.height = this.getFormEditHeight();
    return this.getCenterPosition(screen, formEditRect);
  }

  /**
   * 获取窗口相对屏幕的中心位置
   * @param screen [width, height]
   * @param window [width, height]
   * @returns [left, top]
   */
  public getCenterPosition(screen: WindowRect, window: WindowRect): number[] {
    log.showInfo(TAG, `getCenterPosition, screen:${screen.toString()}, window:${window.toString()}`);
    const left: number = (screen.width - window.width) / 2;
    const top: number = (screen.height - window.height) / 2;
    if (left <= 0 || top <= 0) {
      log.showWarn(TAG, `left or top is less than zero, [${left}, ${top}]`);
      return [0, 0];
    }
    return [left, top];
  }

  /**
   * 获取卡片编辑页位置和大小
   * @returns
   */
  public getFormEditRect(): WindowRect {
    const formEditRect: WindowRect = new WindowRect();
    formEditRect.width = vp2px(this.getFormEditWidth());
    formEditRect.height = vp2px(this.getFormEditHeight());
    const position = this.getFormEditPosition();
    formEditRect.left = vp2px(position[0]);
    formEditRect.top = vp2px(position[1]);
    log.showInfo(TAG, `getFormEditRect, rect:${formEditRect.toString()}`);
    return formEditRect;
  }
}

/**
 * |--------------------------------------------------------------------|
 * |                               title                                |
 * |--------------------------------------------------------------------|
 * |            |             contentMarginTop            |             |
 * |            |-----------------------------------------|             |
 * |            |                                         |             |
 * |            |                                         |             |
 * |            |                                         |             |
 * | marginLeft |                content                  | marginRight |
 * |            |                                         |             |
 * |            |                                         |             |
 * |            |                                         |             |
 * |            |-----------------------------------------|             |
 * |            |          contentMarginBottom            |             |
 * |            |-----------------------------------------|             |
 * |            |                 button                  |             |
 * |            |-----------------------------------------|             |
 * |            |              marginBottom               |             |
 * |--------------------------------------------------------------------|
 */
export class FormEditViewLayout extends FormEditLayout {
  public readonly formEditWidth: number = 528;
  public readonly formEditMinHeight: number = 450;
  public readonly formEditMaxHeight: number = 800;
  public readonly marginLeft: number = 24;

  public readonly titleHeight: number = 56;
  public readonly closeButtonHeight: number = 24;
  public readonly closeButtonMarginRight: number = 16;

  public readonly contentMarginTop: number = 8;
  public readonly contentMarginBottom: number = 16;

  public readonly buttonHeight: number = 40;
  public readonly buttonMarginBottom: number = 24;

  public formEditHeight: number = this.formEditMinHeight;

  public getFormEditWidth(): number {
    return this.formEditWidth;
  }

  public getFormEditHeight(): number {
    return this.formEditHeight;
	}

  public resetParam(): void {
    this.formEditHeight = this.formEditMinHeight;
  }

  public updateFormEditHeight(viewHeight: number = 0): void {
    this.formEditHeight = Math.max(this.formEditMinHeight, Math.min(this.formEditMaxHeight, viewHeight));
    log.showInfo(TAG, `updateFormEditHeight, formEditHeight:${this.formEditHeight}`);
  }

  public getContentWidth(): number {
    return this.formEditWidth - this.marginLeft * 2;
  }

  public getContentHeight(): number {
    return this.formEditHeight - this.titleHeight - this.contentMarginTop - this.contentMarginBottom -
    this.buttonHeight - this.buttonMarginBottom;
  }
}

export class FormEditSecViewLayout extends FormEditLayout {
  public static readonly DEFAULT_BOTTOM_SAFETY_HEIGHT: number = 8;
  public static readonly CREASE_BOTTOM_SAFETY_HEIGHT: number = 16;

  public readonly marginWindowTop: number = 64;
  public readonly marginWindowLeft: number = 24;
  public readonly formEditMinHeight: number = 320;
  public readonly formEditDefaultHeight: number = 560;
  public readonly formEditMaxHeight: number = 672;
  public readonly formEditWidth: number = 480;
  public readonly titleHeight: number = 40;
  public readonly closeButtonSize: number = 40;
  public readonly closeButtonMarginTop: number = 16;
  public readonly closeButtonMarginRight: number = 16;

  public formEditHeight: number = this.formEditDefaultHeight;

  public getFormEditWidth(): number {
    return this.formEditWidth;
  }

  public getFormEditHeight(): number {
    return this.formEditHeight;
  }

  public async updateFormEditHeight(windowProperty?: window.WindowProperties, viewHeight?: number): Promise<void> {
    if (!viewHeight) {
      viewHeight = this.formEditDefaultHeight;
    }
    if (viewHeight <= this.formEditMinHeight) {
      this.formEditHeight = this.formEditMinHeight;
      return;
    }
    // 需避让dock和中轴
    const secViewAvailableHeight = await this.getSecViewAvailableHeight(windowProperty);
    const maxAvailableHeight = Math.min(this.formEditMaxHeight, secViewAvailableHeight);
    this.formEditHeight = Math.max(this.formEditMinHeight, Math.min(viewHeight, maxAvailableHeight));
    log.showInfo(TAG, `updateFormEditHeight, formEditHeight:${this.formEditHeight}, secViewAvailableHeight:${secViewAvailableHeight}`);
  }

  private async getSecViewAvailableHeight(windowProperty?: window.WindowProperties): Promise<number> {
    const displayID = windowProperty?.displayId ?? DEFAULT_DISPLAY_ID;
    const screenAvailableRect = await this.getScreenAvailableArea(displayID);
    const screenAvailableRectBottom = screenAvailableRect.top + screenAvailableRect.height;
    const bottomSafetyHeight = this.getWindowBottomSafetyHeight(displayID);
    const formEditSecViewRectTop = this.getFormEditPosition(windowProperty?.windowRect)[1];
    log.showInfo(TAG, `getAvailableHeight, bottomSafetyHeight:${bottomSafetyHeight}, screenAvailableRect:${screenAvailableRect.toString()}`);
    return px2vp(screenAvailableRectBottom) - bottomSafetyHeight - px2vp(formEditSecViewRectTop);
  }

  private getWindowBottomSafetyHeight(displayID: number): number {
    return FormEditSecViewLayout.DEFAULT_BOTTOM_SAFETY_HEIGHT;
  }

  /**
   * 获取屏幕可用区域，去除了状态栏高度和dock栏高度
   * @param displayID
   * @returns
   */
  private async getScreenAvailableArea(displayID: number): Promise<WindowRect> {
    const availableArea = new WindowRect(displayID);
    try {
      const screenRect = await display.getDisplayByIdSync(displayID).getAvailableArea();
      availableArea.left = screenRect.left;
      availableArea.top = screenRect.top;
      availableArea.width = screenRect.width;
      availableArea.height = screenRect.height;
    } catch (err) {
      log.showInfo(TAG, `getScreenAvailableArea error, errCode:${err?.code}, errMsg:${err?.message}`);
    }
    return availableArea;
  }

  public resetParam(): void {
    this.formEditHeight = this.formEditDefaultHeight;
  }

  public getFormEditPosition(windowRect?: window.Rect): number[] {
    log.showInfo(TAG, `getFormEditPosition, window: { "left": ${windowRect?.left}, "top": ${windowRect?.top} }`);
    if (!windowRect) {
      return super.getFormEditPosition();
    }
    const position: number[] = [];
    position[0] = windowRect.left + vp2px(this.marginWindowLeft);
    position[1] = windowRect.top + vp2px(this.marginWindowTop);
    return position;
  }
}