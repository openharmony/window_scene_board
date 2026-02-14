/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

/* 注意！本文件不允许引入非ohos底座以及SingleManagerDft以外的模块，否则容易导致SingleManager循环依赖 */
import systemDateTime from '@ohos.systemDateTime';
import hilog from '@ohos.hilog';
import { SingleManagerDft } from './SingleManagerDft';
import { SingleManagerDfr } from './SingleManagerDfr';
import { SingleManagerAppStorage } from './SingleManagerAppStorage';

const TAG = 'SingleManager';
const SCB = 0x01b00;

/**
 * 单例管理模块上下文
 */
export interface SingleContext {
  /* 小折叠产品用 */
  isPhoneOuter?: boolean;
  /* 扩展屏功能用 */
  extendScreenId?: number;
}

/**
 * 单例基类，添加到单例管理类的模块都要继承次类，并且完成keyName的初始化
 */
export class SingleBase {
  /**
   * 此变量注册到单例管理类Map中作为Key值，需要唯一。建议各模块使用自己的类名。
   * 这里不能加空，也不能给初值，要求继承类都要赋唯一的初值
   */
  public static singleName: string;
  protected singleContext?: SingleContext;

  constructor(ctx?: SingleContext) {
    this.singleContext = ctx;
  }
}

/**
 * 单例类的构造函数地址
 * 需要支持将context传递给constructor，解决现有代码可以根据ctx在构造阶段通过SingleManager获取成员变量的诉求
 * @deprecated since 2025.08.06
 * @useinstead SingleBaseCtor
 */
export type SingleBaseType<T> = new (ctx?: SingleContext) => T;

export type SingleBaseCtor<T> = (ctx?: SingleContext) => T;

function createClazz<T>(Ctor: SingleBaseCtor<T>, ctx?: SingleContext): T {
  return Ctor(ctx);
}

/* 支持DFT能力的实例类 */
interface SingleInstance {
  instance: SingleBase | undefined;
  dft: SingleManagerDft;
}

/**
 * 多形态产品单例管理类：
 *  支持在不同产品形态、不同产品模式下根据产品定义查找对应的"单例"实例。
 * 数据结构采用二维数组(M * N)的形式保存：
 *                                 宽度N
 *                 —————————————————————————————————————
 *  key: ClassA    | ClassA 01 | ClassA 02 | ClassA 03 |
 *                 —————————————————————————————————————
 *  key: ClassB    | ClassB 01 | ClassB 02 | ClassB 03 |  高度M
 *                 —————————————————————————————————————
 *  key: ClassC    | ClassC 01 | ClassC 02 | ClassC 03 |
 *                 —————————————————————————————————————
 * 不支持场景：
 *  1. 异步逻辑中使用本模块的默认接口，可能会因为内部状态已经变化，获取到非理想的实例
 *  2. 子线程中，子线程的本模块是和主线程不同的实例，可能存在风险。
 */
export class SingleManager {
  private static self?: SingleManager;
  private readonly DEFAULT_ARRAY_SIZE = 1;
  private readonly DEFAULT_ARRAY_INDEX = 0;
  private ctx: SingleContext = { isPhoneOuter: false };
  private singleMap: Map<string, SingleInstance[]> = new Map();
  private initialed: boolean = false;
  private initialTime: number = 0;
  private lastGetTimes: number = 0;
  private dfr: SingleManagerDfr = new SingleManagerDfr(true);
  private appStorage = new SingleManagerAppStorage();
  
  /**
   * size即N值，由产品初始化，这里仅给出初始值
   */
  private arraySize: number = this.DEFAULT_ARRAY_SIZE;
  /**
   * 选择列回调，由产品初始化注册
   */
  private selector?: (ctx: SingleContext) => number;

  /**
   * 获取本模块单例。
   * @returns 单例
   */
  public static getInstance(): SingleManager {
    if (!SingleManager.self) {
      SingleManager.self = new SingleManager();
    }
    return SingleManager.self;
  }

  /**
   * 初始化配置，对于需要支持多实例的产品，要在Product仓启动的时候调用一次；
   * 如果只支持单实例，可以不初始化，默认按照单实例处理
   *
   * @param size 同类型实例的个数N
   * @param initial 初始化SingleContext类，产品此时初始化需要用于判断的参数
   * @param selector 根据initialContext返回实例的下标，在get时执行。提供给产品适配不同参数下的实例下标地址，返回结果范围[0, N)。
   */
  public initial(size: number, initialContext: (ctx: SingleContext) => void,
    selector: (ctx: SingleContext) => number): void {
    if (this.initialed) {
      hilog.warn(SCB, TAG, 'You should not initial repeatedly.');
      return;
    }

    this.arraySize = size ?? this.DEFAULT_ARRAY_SIZE;
    this.selector = selector;
    initialContext(this.ctx);

    this.initialed = true;
    this.initialTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, true);
  }

  /**
   * 注册指定类型到管理模块中。
   * 此接口有2种典型使用场景：
   * 1. 将初始化的单例注册到首实例，调用register(class, instance)
   * 2. 将初始化的单例注册到指定位置，如PC继承了平台类，调用register(pcClass, pcInstance, pcContext);
   * 对于第二种方法，还可以用get实现相同的效果
   *
   * @param cls 类型名
   * @param dftSingle 实例地址，用于兼容已有的getInstance。
   * @param target 调用者指定的SingleContext上下文，用于调用者指定实例地址的场景。如果不传则保存到首实例。
   */
  public register<T extends SingleBase>(className: Function, dftSingle: T, target?: SingleContext): void {
    if (!this.checkKeyNameWithFun<T>(className, 'on register')) {
      throw new Error('SingleManager: invalid keyName.');
    }
    let name = this.getKeyNameWithFun<T>(className);
    let arr = this.findArrayWithFun<T>(className);
    if (arr) {
      hilog.debug(SCB, TAG, `Object ${name} has been registered.`);
    } else {
      hilog.debug(SCB, TAG, `Create new object ${name} support ${this.arraySize} instances when registering.`);
      arr = this.addArrayWithFun<T>(className);
    }
    this.createExistedItem(name, arr, dftSingle, target);
  }

  /**
   * 根据当前SingleContext类状态，查找指定类型的实例。
   * 注意：此接口在查找不到实例的时候会抛出异常，原始单例是不会的，出现情况可能:
   *      1. 产品在initial时传入的initialContext以及selector不匹配，selector返回数组越界;
   *      2. 模块未初始化
   *      3. 查找类型传错，未正确设置singleName
   *      4. 内部逻辑错误，实例内容为空
   *      5. 查找到的实例类型和目标类型不匹配
   * @param className 类型名。实际上是构造函数的地址
   * @param target 调用者指定的SingleContext上下文，用于调用者指定实例的场景
   * @returns 实例地址
   * @deprecated since 2025.08.06
   * @useinstead SingleManager.getInstance
   */
  public get<T extends SingleBase>(className: SingleBaseType<T>, target?: SingleContext): T {
    if (!this.checkKeyName(className, 'on get')) {
      throw new Error('SingleManager: invalid keyName.');
    }
    let name = this.getKeyName(className);
    let arr = this.findArray(className);
    if (!arr) {
      hilog.debug(SCB, TAG, `Create new object ${name} support ${this.arraySize} instances when getting.`);
      arr = this.addArray(className);
    }
    hilog.debug(SCB, TAG, `We find object ${name} array.`);
    let index = this.getIndex(arr, target);
    if (index === undefined) {
      throw new Error(`SingleManager: Selector callback return object ${name} index is invalid.`);
    }
    if (!arr[index]) {
       arr[index] = this.createNewItem(className, target);
    }
    const instance = arr[index];
    if (!instance.instance) {
      throw new Error(`SingleManager: Object ${name} has null instance with index ${index}.`);
    }
    if (!this.dfr.isInstance<T>(className, instance.instance as T)) {
      throw new Error(`SingleManager: Get object ${name} with incorrect type.`);
    }

    instance.dft.recordGetTime();
    return instance.instance as T;
  }

  /**
   * 根据当前SingleContext类状态，查找指定类型的实例。
   * 注意：此接口在查找不到实例的时候会抛出异常，原始单例是不会的，出现情况可能:
   *      1. 产品在initial时传入的initialContext以及selector不匹配，selector返回数组越界;
   *      2. 模块未初始化
   *      3. 查找类型传错，未正确设置singleName
   *      4. 内部逻辑错误，实例内容为空
   *      5. 查找到的实例类型和目标类型不匹配
   * @param className 类型名。实际上是构造函数的地址:用于获取singleName
   * @param ctor 构造函数
   * @param target 调用者指定的SingleContext上下文，用于调用者指定实例的场景
   * @returns 实例地址
   */
  public getInstance<T extends SingleBase>(className: Function, ctor: SingleBaseCtor<T>, target?: SingleContext): T {
    if (!this.checkKeyNameWithFun<T>(className, 'on get')) {
      throw new Error('SingleManager: invalid keyName.');
    }
    let name = this.getKeyNameWithFun<T>(className);
    let arr = this.findArrayWithFun<T>(className);
    if (!arr) {
      hilog.debug(SCB, TAG, `Create new object ${name} support ${this.arraySize} instances when getting.`);
      arr = this.addArrayWithFun<T>(className);
    }
    hilog.debug(SCB, TAG, `We find object ${name} array.`);
    let index = this.getIndex(arr, target);
    if (index === undefined) {
      throw new Error(`SingleManager: Selector callback return object ${name} index is invalid.`);
    }
    if (!arr[index]) {
      arr[index] = this.createNewItemWithCtor(className, ctor, target);
    }
    const instance = arr[index];
    if (!instance.instance) {
      throw new Error(`SingleManager: Object ${name} has null instance with index ${index}.`);
    }

    instance.dft.recordGetTime();
    return instance.instance as T;
  }

  public getAppStorageName(src: string, target?: SingleContext): string {
    let index = this.getIndex(undefined, target);
    if (index === undefined) {
      throw new Error(`SingleManager: Selector callback return AppStorage ${src} index is invalid.`);
    }
    return this.appStorage.getName(src, index);
  }

  /**
   * DFX能力：打开DFT功能
   * @param lastGetTimes 允许保存的获取时间的数组大小
   */
  public enableDft(lastGetTimes: number): void {
    this.singleMap?.forEach((array: SingleInstance[]) => {
      array.forEach((item: SingleInstance) => {
        item?.dft.setGetTimeSize(lastGetTimes);
      });
    });
  }

  /**
   * DFX能力：打开DFR功能
   * @param enable 开启get时校验类型
   */
  public enableDfr(enable: boolean): void {
    this.dfr.setEnable(enable);
  }

  /**
   * DFX能力：获取描述字符串
   * @returns 描述字符串
   */
  public toString(): string {
    let desc: string = `Single manager is initialed at ` +
      `${this.initialTime.toString()}, has ${this.singleMap.size} singles in map.\n`;
    this.singleMap.forEach((values: SingleInstance[], key: string) => {
      let sub: string = `  single item: ${key}\n`;
      values.forEach((value: SingleInstance, index) => {
        let line: string = `    INSTANCE: ${(index + 1)} ` +
          `CONTENT: ${this.getContent(value.instance)}\n`;
        line += `      Basic  DFT info: ${value.dft.toBasicString()}\n`;
        line += `      Detail DFT info: ${value.dft.toDetailString()}\n`;
        sub += line;
      });
      desc += sub;
    });
    return desc;
  }

  private getContent(instance: SingleBase | undefined): string {
    try {
      return JSON.stringify(instance).substring(0, 40);
    } catch (jsonError) {
      return 'cannot convert instance to string';
    }
  }

  private isInitialed(): boolean {
    if (this.initialed) {
      return true;
    }
    return false;
  }

  private checkKeyName<T>(clas: SingleBaseType<T>, msg: string): boolean {
    if (!clas || !clas['singleName'] || typeof clas['singleName'] !== 'string') {
      hilog.error(SCB, TAG, `Single object keyname ${clas?.['singleName']} invalid ${msg}.`);
      return false;
    }
    return true;
  }

  private getKeyName<T>(single: SingleBaseType<T>): string {
    return single['singleName'] as string;
  }

  private findArray<T>(single: SingleBaseType<T>): SingleInstance[] | undefined {
    return this.singleMap.get(this.getKeyName(single));
  }

  private addArray<T>(creator: SingleBaseType<T>): SingleInstance[] {
    const array = new Array<SingleInstance>(this.arraySize);
    const name = this.getKeyName(creator);
    hilog.debug(SCB, TAG, `Object ${name} array is created`);
    this.singleMap.set(name, array);

    return array;
  }

  private checkKeyNameWithFun<T>(clas: Function, msg: string): boolean {
    if (!clas) {
      hilog.error(SCB, TAG, `Single object keyname args error, invalid ${msg}.`);
      return false;
    }
    let singleName: string = Reflect.get(clas, 'singleName');
    if (!singleName) {
      hilog.error(SCB, TAG, `Single object keyname get prop error, invalid ${msg}.`);
      return false;
    }
    if (typeof singleName !== 'string') {
      hilog.error(SCB, TAG, `Single object keyname prop type error, invalid ${msg}.`);
      return false;
    }
    return true;
  }

  private getKeyNameWithFun<T>(single: Function): string {
    return Reflect.get(single, 'singleName');
  }

  private findArrayWithFun<T>(single: Function): SingleInstance[] | undefined {
    return this.singleMap.get(this.getKeyNameWithFun<T>(single));
  }

  private addArrayWithFun<T>(creator: Function): SingleInstance[] {
    const array = new Array<SingleInstance>(this.arraySize);
    const name = this.getKeyNameWithFun<T>(creator);
    hilog.debug(SCB, TAG, `Object ${name} array is created`);
    this.singleMap.set(name, array);
    return array;
  }

  private getIndex(array?: SingleInstance[], target?: SingleContext): number | undefined {
    let i: number = 0;
    if (this.selector) {
      i = this.selector(target ?? this.ctx);
    }
    if (i === undefined || i === null || i < 0) {
      hilog.error(SCB, TAG, `Selector callback return object instance ${i} is invalid.`);
      return undefined;
    }

    if (array !== undefined) {
      if (i >= array.length) {
        hilog.error(SCB, TAG, `Selector callback return object instance ${i} exceed the array size ${array.length}.`);
        return undefined;
      }
    } else {
      if (i >= this.arraySize) {
        hilog.error(SCB, TAG, `Selector callback return object instance ${i} exceed array size ${this.arraySize}.`);
        return undefined;
      }
    }

    return i;
  }

  private createNewItem<T>(creator: SingleBaseType<T>, target?: SingleContext): SingleInstance {
    hilog.debug(SCB, TAG, `Object ${this.getKeyName(creator)} instance is created`);

    let item: SingleInstance = { instance: new creator(target), dft: new SingleManagerDft(this.lastGetTimes) };
    item.dft.recordCreateTime();

    return item;
  }

  private createNewItemWithCtor<T>(className: Function, creator: SingleBaseCtor<T>,
    target?: SingleContext): SingleInstance {
    hilog.debug(SCB, TAG, `Object ${this.getKeyNameWithFun<T>(className)} instance is created`);
    let item: SingleInstance = { instance: createClazz(creator, target), dft: new SingleManagerDft(this.lastGetTimes) };
    item.dft.recordCreateTime();
    return item;
  }

  private createExistedItem(name: string, array: SingleInstance[], instance: SingleBase,
    target?: SingleContext): void {
    let i: number | undefined = this.DEFAULT_ARRAY_INDEX;
    if (target) {
      i = this.getIndex(array, target);
      if (i === undefined) {
        return;
      }
      hilog.debug(SCB, TAG, `Object ${name} instance ${i} will be set`);
    } else {
      hilog.debug(SCB, TAG, `Object ${name} instance ${this.DEFAULT_ARRAY_INDEX} will be set`);
    }
    if (!array[i]) {
      let item: SingleInstance = { instance: undefined, dft: new SingleManagerDft(this.lastGetTimes) };
      array[i] = item;
    } else {
      hilog.warn(SCB, TAG, `Object ${name} instance ${i} has been set before, replace it.`);
    }
    array[i].instance = instance;
    array[i].dft.recordCreateTime();
  }
}

export let singleManager: SingleManager = SingleManager.getInstance();