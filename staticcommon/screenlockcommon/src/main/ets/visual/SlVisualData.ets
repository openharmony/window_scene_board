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
import effectKit from '@ohos.effectKit';
import CommonConstants, {
  PictureLightColorDegree,
  SlAreaType,
  SlPositionType,
} from '../constants/CommonConstants';

/**
 * 壁纸和组件坐标传入colorPicker计算出的背景壁纸信息,作为缓存单元
 */
export class BackCacheUnit {
  /**
   * 壁纸背景平均色
   */
  private _color: effectKit.Color = CommonConstants.DEFAULT_BRIGHT_RGB_COLOR;

  /**
   * 壁纸深浅程度
   */
  private _degree: PictureLightColorDegree = PictureLightColorDegree.UNKOWN_LIGHT_COLOR_DEGREE_PICTURE;

  public static wrapper(color: effectKit.Color, degree: PictureLightColorDegree): BackCacheUnit {
    let info = new BackCacheUnit();
    info._color = color;
    info._degree = degree;
    return info;
  }

  /**
   * 查询对应区域当前壁纸的类型是否为浅色壁纸
   *
   * @param wallPaperType 壁纸类型
   * @returns true为浅色
   */
  public getIsLightStatus(): boolean {
    return this._degree === PictureLightColorDegree.EXTREMELY_LIGHT_COLOR_PICTURE;
  }

  public get color(): effectKit.Color {
    return this._color;
  }

  public get degree(): PictureLightColorDegree {
    return this._degree;
  }
}

/**
 * 锁屏布局区域信息
 */
export class SlArea {
  /**
   * 区分组件区域的唯一标识
   */
  private _areaType: SlAreaType = SlAreaType.DEFAULT;

  /**
   * 区域的坐标，用以计算提亮后的颜色
   * 数组元素个数为4，取值范围为[0, 1]，
   * 数组元素分别表示图片区域的左、上、右、下位置，图片最左侧和最上侧对应位置0，最右侧和最下侧对应位置1。
   * 数组第三个元素需大于第一个元素，第四个元素需大于第二个元素
   * [left, top, right, bottom]
   * [0, 0, 1, 1]
   */
  private _position: number[] = CommonConstants.DEFAULT_WIDGET_AREA;

  /**
   * 当前区域类的所有提亮参数
   */
  private _argsArr: SlPositionType[] = [];

  /**
   * 构造函数
   *
   * @param areaType 组件区域类型
   * @param componentArr 区域内的组件
   */
  constructor(areaType: SlAreaType) {
    this._areaType = areaType;
  }

  public printPosition(): string {
    let res = '';
    this._position.forEach((num: number) => {
      res += (' ' + num);
    });
    return res;
  }

  public set areaType(value: SlAreaType) {
    this._areaType = value;
  }

  public get areaType(): SlAreaType {
    return this._areaType;
  }

  public set position(value: number[]) {
    this._position = value;
  }

  public get position(): number[] {
    return this._position;
  }

  public get argsArr(): SlPositionType[] {
    return this._argsArr;
  }
}

/**
 * 锁屏组件具体场景提亮参数
 *
 */
@Observed
export class SlVisualArgs {
  /**
   * 参数在页面中的使用位置，例如内容胶囊背板
   */
  private _positionType: SlPositionType = SlPositionType.DEFAULT;

  /**
   * 计算纯色时对应的壁纸区域，例如胶囊区域、时钟区域等
   */
  private _areaType: SlAreaType = SlAreaType.DEFAULT;

  /**
   * 组件注册的原始提亮参数
   */
  private _brightness: BrightnessOptions | undefined;

  /**
   * 中档视效或纯色计算失败时使用的默认颜色
   * 该颜色由提亮参数根据算法直接实现，不依赖于壁纸背景色
   */
  private _defaultBrightColor: ResourceColor | string = CommonConstants.DEFAULT_BRIGHT_COLOR;

  /**
   * 根据壁纸背景色和提亮参数由提亮算法计算的组件纯色
   */
  private _brightColor?: ResourceColor | string;

  /**
   * 组件注册的原始压暗参数
   */
  private _darkness: BrightnessOptions | undefined;

  /**
   * 中档视效或纯色计算失败时使用的默认颜色
   * 该颜色由压暗参数根据算法直接实现，不依赖于壁纸背景色
   */
  private _defaultDarkColor: ResourceColor | string = CommonConstants.DEFAULT_DARK_COLOR;

  /**
   * 根据壁纸背景色和压暗参数由提亮算法计算的组件纯色
   */
  private _darkColor?: ResourceColor | string;

  /**
   * true表示需要提亮, false表示需要压暗，用于判断并输出提亮或压暗的参数
   */
  private _needBright: boolean = true;

  constructor(builder: SlVisualArgsBuilder) {
    this._positionType = builder.positionType;
    this._areaType = builder.areaType;
    this._brightness = builder.brightness;
    this._defaultBrightColor = builder.defaultBrightColor;
    this._darkness = builder.darkness;
    this._defaultDarkColor = builder.defaultDarkColor;
  }

  /**
   * 查询提亮算法计算后的纯色
   *
   * isDarkMode true深色模式, false浅色模式, 未赋值表示使用壁纸反色
   * @returns 提亮算法计算后的纯色， 提亮颜色或压暗颜色
   */
  public getSolidColor(isDarkMode?: boolean): ResourceColor | string {
    if (isDarkMode === true) {
      return this._darkColor ?? this._defaultDarkColor;
    } else if (isDarkMode === false) {
      return this._brightColor ?? this._defaultBrightColor;
    }

    if (this._needBright) {
      return this._brightColor ?? this._defaultBrightColor;
    } else {
      return this._darkColor ?? this._defaultDarkColor;
    }
  }

  /**
   * 获取提亮参数计算后的颜色
   *
   * isLightWallpaper true浅色
   * @returns 提亮参数计算后的颜色
   */
  public getBrightnessColor(isLightWallpaper?: boolean): ResourceColor | string {
    return isLightWallpaper ? this._defaultDarkColor : this._defaultBrightColor;
  }

  /**
   * 查询UI界面实际提亮压暗参数
   *
   * isDarkMode true深色模式, false浅色模式, 未赋值表示使用壁纸反色
   * @returns 提亮压暗参数
   */
  public getUiBrightness(isDarkMode?: boolean): BrightnessOptions | undefined {
    if (isDarkMode === true) {
      return this._darkness;
    } else if (isDarkMode === false) {
      return this._brightness;
    }

    return this._needBright ? this._brightness : this._darkness;
  }

  public set positionType(value: SlPositionType) {
    this._positionType = value;
  }

  public get positionType(): SlPositionType {
    return this._positionType;
  }

  public set areaType(value: SlAreaType) {
    this._areaType = value;
  }

  public get areaType(): SlAreaType {
    return this._areaType;
  }

  public set brightness(value: BrightnessOptions | undefined) {
    this._brightness = value;
  }

  public get brightness(): BrightnessOptions | undefined {
    return this._brightness;
  }

  public set defaultBrightColor(value: ResourceColor | string) {
    this._defaultBrightColor = value;
  }

  public get defaultBrightColor(): ResourceColor | string {
    return this._defaultBrightColor;
  }

  public set brightColor(value: ResourceColor | string | undefined) {
    this._brightColor = value;
  }

  public get brightColor(): ResourceColor | string | undefined {
    return this._brightColor;
  }

  public set darkness(value: BrightnessOptions | undefined) {
    this._darkness = value;
  }

  public get darkness(): BrightnessOptions | undefined {
    return this._darkness;
  }

  public set defaultDarkColor(value: ResourceColor | string) {
    this._defaultDarkColor = value;
  }

  public get defaultDarkColor(): ResourceColor | string {
    return this._defaultDarkColor;
  }

  public set darkColor(value: ResourceColor | string | undefined) {
    this._darkColor = value;
  }

  public get darkColor(): ResourceColor | string | undefined {
    return this._darkColor;
  }

  public get needBright(): boolean {
    return this._needBright;
  }

  public set needBright(value: boolean) {
    this._needBright = value;
  }
}


/**
 * SlVisualArgs类初始化的参数较多，通过SlVisualArgsBuilder建造起创建新的实例
 */
export class SlVisualArgsBuilder {
  private static instance = new SlVisualArgsBuilder();

  private _positionType: SlPositionType = SlPositionType.DEFAULT;

  private _areaType: SlAreaType = SlAreaType.DEFAULT;

  private _brightness: BrightnessOptions | undefined;

  private _defaultBrightColor: ResourceColor | string = '';

  private _darkness: BrightnessOptions | undefined;

  private _defaultDarkColor: ResourceColor | string = '';

  public static builder(): SlVisualArgsBuilder {
    return SlVisualArgsBuilder.instance;
  }

  public get positionType(): SlPositionType {
    return this._positionType;
  }

  public get areaType(): SlAreaType {
    return this._areaType;
  }

  public get brightness(): BrightnessOptions | undefined {
    return this._brightness;
  }

  public get defaultBrightColor(): ResourceColor | string {
    return this._defaultBrightColor;
  }

  public get darkness(): BrightnessOptions | undefined {
    return this._darkness;
  }

  public get defaultDarkColor(): ResourceColor | string {
    return this._defaultDarkColor;
  }

  public withPositionType(value: SlPositionType): SlVisualArgsBuilder {
    this._positionType = value;
    return this;
  }

  public withAreaType(value: SlAreaType): SlVisualArgsBuilder {
    this._areaType = value;
    return this;
  }

  public withBrightness(value: BrightnessOptions | undefined): SlVisualArgsBuilder {
    this._brightness = value;
    return this;
  }

  public withDefaultBrightColor(defaultBrightColor: ResourceColor | string): SlVisualArgsBuilder {
    this._defaultBrightColor = defaultBrightColor;
    return this;
  }

  public withDarkness(value: BrightnessOptions | undefined): SlVisualArgsBuilder {
    this._darkness = value;
    return this;
  }

  public withDefaultDarkColor(defaultDarkColor: ResourceColor | string): SlVisualArgsBuilder {
    this._defaultDarkColor = defaultDarkColor;
    return this;
  }

  public build(): SlVisualArgs {
    return new SlVisualArgs(this);
  }
}