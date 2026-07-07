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

/**
 * 桌面参数
 */
export class DesktopParam {
  private _curColorMode: number = 0;

  private _gridMarginTop: number = 0;

  private _nameFontColor: string = '';

  private _filesDir: string = '';

  private _cacheDir: string = '';

  private _iconRadius: number = 0;

  private _gridWidth: number = 0;

  private _gridHeight: number = 0;

  private _bigFolderRadius: number = 0;

  private _smallFolderRadius: number = 0;

  private _rows: number = 0;

  private _columns: number = 0;

  private _screenWidth: number = 0;

  private _screenHeight: number = 0;

  private _workSpaceHeight: number = 0;

  private _workSpaceWidth: number = 0;

  private _iconSize: number = 0;

  private _iconChangeSize: number = 0;

  private _marginBottomOfIndicator: number = 0;

  private _dockHeight: number = 0;

  /**
   * 列间距,计算卡片大小
   */
  private _spaceOfColumn: number = 0;

  /**
   * 行间距,计算卡片大小
   */
  private _spaceOfRow: number = 0;

  private _formItemSizeOffset: number = 0;

  private _columnGaps: number = 0;

  private _rowGaps: number = 0;

  private _nameSize: number = 0;

  private _nameLines: number = 0;

  private _nameMarginTop: number = 0;

  private _iconMarginVertical: number = 0;

  private _formRadius: number = 0;

  private _backgroundBrightness: number = 0;

  private _itemPadding: number = 0;

  private _isShowName: boolean = false;

  private _darkWallpaper: boolean = false;

  private _enableBrightness: boolean = false;

  private _enableBlur: boolean = false;

  private _voiceCardName: string = '';

  private _isDarkMode: boolean = false;

  private _wallpaperType: number = 0;

  private _statusBarHeight: number = 0;

  private _fontSizeScale: number = 0;

  private _isNeedAppNameShadow: boolean = false;

  private _isFoldExpandedInLandscape: boolean = false;

  private _singlePageFoldScreenWidth: number = 0;

  private _isAccessibilityMode: boolean = false;

  private _vp2pxScale: number = 0;

  private _iconPath: string = '';

  private _clockStyle: string = '';

  private _mMargin: number = 0;

  private _isRTL: boolean = false;

  /**
   * 是否简易模式
   */
  private _isSimpleMode: boolean = false;

  private _isOuterDesktop: boolean = false;

  private _previewScale: number = 1;

  /**
   * displayCount
   */
  private _displayCount: number = 1;

  /**
   * foldPaddingSide
   */
  private _foldPaddingSide: number = 0;

  /**
   * isOnlineTheme
   */
  private _isOnlineTheme: boolean = false;

  public set clockStyle(value: string) {
    this._clockStyle = value;
  }

  public get clockStyle(): string {
    return this._clockStyle;
  }

  public set smallFolderRadius(value: number) {
    this._smallFolderRadius = value;
  }

  public get smallFolderRadius(): number {
    return this._smallFolderRadius;
  }

  public set bigFolderRadius(value: number) {
    this._bigFolderRadius = value;
  }

  public get bigFolderRadius(): number {
    return this._bigFolderRadius;
  }

  public set iconMarginVertical(value: number) {
    this._iconMarginVertical = value;
  }

  public get iconMarginVertical(): number {
    return this._iconMarginVertical;
  }

  public set itemPadding(value: number) {
    this._itemPadding = value;
  }

  public get itemPadding(): number {
    return this._itemPadding;
  }

  public set gridMarginTop(value: number) {
    this._gridMarginTop = value;
  }

  public get gridMarginTop(): number {
    return this._gridMarginTop;
  }

  public set workSpaceHeight(value: number) {
    this._workSpaceHeight = value;
  }

  public get workSpaceHeight(): number {
    return this._workSpaceHeight;
  }

  public set workSpaceWidth(value: number) {
    this._workSpaceWidth = value;
  }

  public get workSpaceWidth(): number {
    return this._workSpaceWidth;
  }

  public set formItemSizeOffset(value: number) {
    this._formItemSizeOffset = value;
  }

  public get formItemSizeOffset(): number {
    return this._formItemSizeOffset;
  }

  public set enableBrightness(value: boolean) {
    this._enableBrightness = value;
  }

  public get enableBrightness(): boolean {
    return this._enableBrightness;
  }

  public set enableBlur(value: boolean) {
    this._enableBlur = value;
  }

  public get enableBlur(): boolean {
    return this._enableBlur;
  }

  public set backgroundBrightness(value: number) {
    this._backgroundBrightness = value;
  }

  public get backgroundBrightness(): number {
    return this._backgroundBrightness;
  }

  public set iconRadius(value: number) {
    this._iconRadius = value;
  }

  public get iconRadius(): number {
    return this._iconRadius;
  }

  public set filesDir(value: string) {
    this._filesDir = value;
  }

  public get filesDir(): string {
    return this._filesDir;
  }

  public set cacheDir(value: string) {
    this._cacheDir = value;
  }

  public get cacheDir(): string {
    return this._cacheDir;
  }

  public set dockHeight(value: number) {
    this._dockHeight = value;
  }

  public get dockHeight(): number {
    return this._dockHeight;
  }

  public set marginBottomOfIndicator(value: number) {
    this._marginBottomOfIndicator = value;
  }

  public get marginBottomOfIndicator(): number {
    return this._marginBottomOfIndicator;
  }

  public set darkWallpaper(value: boolean) {
    this._darkWallpaper = value;
  }

  public get darkWallpaper(): boolean {
    return this._darkWallpaper;
  }

  public set iconSize(value: number) {
    this._iconSize = value;
  }

  public get iconSize(): number {
    return this._iconSize;
  }

  public set iconChangeSize(value: number) {
    this._iconChangeSize = value;
  }

  public get iconChangeSize(): number {
    return this._iconChangeSize;
  }

  public set nameFontColor(value: string) {
    this._nameFontColor = value;
  }

  public get nameFontColor(): string {
    return this._nameFontColor;
  }

  public set gridWidth(value: number) {
    this._gridWidth = value;
  }

  public get gridWidth(): number {
    return this._gridWidth;
  }

  public set gridHeight(value: number) {
    this._gridHeight = value;
  }

  public get gridHeight(): number {
    return this._gridHeight;
  }

  public set columns(value: number) {
    this._columns = value;
  }

  public get columns(): number {
    return this._columns;
  }

  public set rows(value: number) {
    this._rows = value;
  }

  public get rows(): number {
    return this._rows;
  }

  public set screenHeight(value: number) {
    this._screenHeight = value;
  }

  public get screenHeight(): number {
    return this._screenHeight;
  }

  public set screenWidth(value: number) {
    this._screenWidth = value;
  }

  public get screenWidth(): number {
    return this._screenWidth;
  }

  public set spaceOfColumn(value: number) {
    this._spaceOfColumn = value;
  }

  public get spaceOfColumn(): number {
    return this._spaceOfColumn;
  }

  public set spaceOfRow(value: number) {
    this._spaceOfRow = value;
  }

  public get spaceOfRow(): number {
    return this._spaceOfRow;
  }

  public set columnGaps(value: number) {
    this._columnGaps = value;
  }

  public get columnGaps(): number {
    return this._columnGaps;
  }

  public set rowGaps(value: number) {
    this._rowGaps = value;
  }

  public get rowGaps(): number {
    return this._rowGaps;
  }

  public set nameSize(value: number) {
    this._nameSize = value;
  }

  public get nameSize(): number {
    return this._nameSize;
  }

  public set nameLines(value: number) {
    this._nameLines = value;
  }

  public get nameLines(): number {
    return this._nameLines;
  }

  public set nameMarginTop(value: number) {
    this._nameMarginTop = value;
  }

  public get nameMarginTop(): number {
    return this._nameMarginTop;
  }

  public set formRadius(value: number) {
    this._formRadius = value;
  }

  public get formRadius(): number {
    return this._formRadius;
  }

  public set isShowName(value: boolean) {
    this._isShowName = value;
  }

  public get isShowName(): boolean {
    return this._isShowName;
  }

  public set curColorMode(value: number) {
    this._curColorMode = value;
  }

  public get curColorMode(): number {
    return this._curColorMode;
  }

  public set voiceCardName(value: string) {
    this._voiceCardName = value;
  }

  public get voiceCardName(): string {
    return this._voiceCardName;
  }

  public set isDarkMode(value: boolean) {
    this._isDarkMode = value;
  }

  public get isDarkMode(): boolean {
    return this._isDarkMode;
  }

  public set wallpaperType(value: number) {
    this._wallpaperType = value;
  }

  public get wallpaperType(): number {
    return this._wallpaperType;
  }

  public set statusBarHeight(value: number) {
    this._statusBarHeight = value;
  }

  public get statusBarHeight(): number {
    return this._statusBarHeight;
  }

  public set fontSizeScale(value: number) {
    this._fontSizeScale = value;
  }

  public get fontSizeScale(): number {
    return this._fontSizeScale;
  }

  public set isNeedAppNameShadow(value: boolean) {
    this._isNeedAppNameShadow = value;
  }

  public get isNeedAppNameShadow(): boolean {
    return this._isNeedAppNameShadow;
  }

  public set isFoldExpandedInLandscape(value: boolean) {
    this._isFoldExpandedInLandscape = value;
  }

  public get isFoldExpandedInLandscape(): boolean {
    return this._isFoldExpandedInLandscape;
  }

  public set singlePageFoldScreenWidth(value: number) {
    this._singlePageFoldScreenWidth = value;
  }

  public get singlePageFoldScreenWidth(): number {
    return this._singlePageFoldScreenWidth;
  }

  public set isAccessibilityMode(value: boolean) {
    this._isAccessibilityMode = value;
  }

  public get isAccessibilityMode(): boolean {
    return this._isAccessibilityMode;
  }

  public set vp2pxScale(value: number) {
    this._vp2pxScale = value;
  }

  public get vp2pxScale(): number {
    return this._vp2pxScale;
  }

  public set iconPath(value: string) {
    this._iconPath = value;
  }

  public get iconPath(): string {
    return this._iconPath;
  }

  public set mMargin(value: number) {
    this._mMargin = value;
  }

  public get mMargin(): number {
    return this._mMargin;
  }

  public set isRTL(value: boolean) {
    this._isRTL = value;
  }

  public get isRTL(): boolean {
    return this._isRTL;
  }

  public set isSimpleMode(value: boolean) {
    this._isSimpleMode = value;
  }

  public get isSimpleMode(): boolean {
    return this._isSimpleMode;
  }


  public set previewScale(value: number) {
    this._previewScale = value;
  }

  public get previewScale(): number {
    return this._previewScale;
  }

  public set isOuterDesktop(value: boolean) {
    this._isOuterDesktop = value;
  }

  public get isOuterDesktop(): boolean {
    return this._isOuterDesktop;
  }

  public set displayCount(value: number) {
    this._displayCount = value;
  }

  public get displayCount(): number {
    return this._displayCount;
  }

  public set foldPaddingSide(value: number) {
    this._foldPaddingSide = value;
  }

  public get foldPaddingSide(): number {
    return this._foldPaddingSide;
  }
  
  public set isOnlineTheme(value: boolean) {
    this._isOnlineTheme = value;
  }

  public get isOnlineTheme(): boolean {
    return this._isOnlineTheme;
  }
}