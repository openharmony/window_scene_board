/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import type { SCBPropertyChangeReason } from '../screen/session/SCBScreenSessionManager';
import type { SCBScreenProperty } from '../screen/session/SCBScreenSession';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';

const RECENT_TAG = 'RecentPanel';
const recentLog = LogHelper.getLogHelper(LogDomain.RECENT, RECENT_TAG);

export class RecentViewParam {
  private _rotation: number = 0;
  // Cannot change unless the screen property is changed.
  private _recentW: number;
  private _recentH: number;
  private _screenProperty: SCBScreenProperty;

  private _recentPadding: number = 0;
  private _recentTransX: number = 0;
  private _recentTransY: number = 0;
  private _recentAlpha: number = 1;

  constructor(screenProperty: SCBScreenProperty) {
    this.screenProperty = screenProperty;
    this.recentW = this.screenProperty.width;
    this.recentH = this.screenProperty.height;
  }

  public set rotation(value : number) {
    this._rotation = value;
  }

  public get rotation(): number {
    return this._rotation;
  }

  public set recentW(value : number) {
    if (CommonUtils.equals(this._recentW, value)) {
      return;
    }
    recentLog.showWarn(`set recentW from ${this._recentW} to ${value}`);
    this._recentW = value;
  }

  public get recentW(): number {
    return this._recentW;
  }

  public set recentH(value : number) {
    this._recentH = value;
  }

  public get recentH(): number {
    return this._recentH;
  }

  public set screenProperty(value : SCBScreenProperty) {
    this._screenProperty = value;
  }

  public get screenProperty(): SCBScreenProperty {
    return this._screenProperty;
  }

  public set recentPadding(value : number) {
    this._recentPadding = value;
  }

  public get recentPadding(): number {
    return this._recentPadding;
  }

  public set recentTransX(value : number) {
    this._recentTransX = value;
  }

  public get recentTransX(): number {
    return this._recentTransX;
  }

  public set recentTransY(value : number) {
    this._recentTransY = value;
  }

  public get recentTransY(): number {
    return this._recentTransY;
  }

  public set recentAlpha(value : number) {
    this._recentAlpha = value;
  }

  public get recentAlpha(): number {
    return this._recentAlpha;
  }

  /**
   * init properties of scenePanelView
   */
  public initAll(): void {
    recentLog.showInfo('RecentViewParam init');
    this.recentW = this.screenProperty.width;
    this.recentH = this.screenProperty.height;
    this.recentPadding = 0;
    this.recentTransX = 0;
    this.recentTransY = 0;
    this.recentAlpha = 1;
  }

  public onScreenChange(screenProperty: SCBScreenProperty,
                        reason: SCBPropertyChangeReason): void {
    if (!screenProperty) {
      recentLog.showInfo(`screenProperty is null, just return`);
      return;
    }
    recentLog.showInfo(`RecentViewParam before change recentW:${this.recentW} recentH:${this.recentH}` +
      ` rotation:${this.rotation} reason:${reason} screenRotation:${screenProperty.rotation}` +
      ` recentScreenW:${this.screenProperty.width} recentScreenH:${this.screenProperty.height}`);
    this.initAll();
    this.rotation = screenProperty.rotation;
    recentLog.showInfo(`RecentViewParam after change recentW:${this.recentW} recentH:${this.recentH}` +
      ` rotation:${this.rotation} reason:${reason} screenRotation:${screenProperty.rotation}` +
      ` recentScreenW:${this.screenProperty.width} recentScreenH:${this.screenProperty.height}`);
  }

  public toString(): string {
    return `recentTransX: ${this.recentTransX}, recentTransY: ${this.recentTransY}, recentAlpha: ${this.recentAlpha}, recentW:${this.recentW}, recentH:${this.recentH}`;
  }
}
