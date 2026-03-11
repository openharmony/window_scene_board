/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog';
import { AnimateParam } from 'AnimateToParam';
import { LogDomain, SingletonHelper } from '@ohos/basicutils';

const DOMAIN = LogDomain.RECENT;

export enum AnimateExState {
  INIT = 'init',
  ANIMATING = 'animating',
  BROKEN = 'broken',
  DONE = 'done'
}

export type AnimateExArgsType = boolean | number | string | object | undefined;

export type AnimateExCallback = (...args: AnimateExArgsType[]) => void;

class AnimateExSkeleton {
  private readonly TAG: string = 'AnimateExSkeleton';
  private overrideParam: AnimateParam = {};
  private originEvents: AnimateExCallback[] = [];
  private unBreakableOnFinish: AnimateExCallback[] = [];
  private breakableOnFinish: AnimateExCallback[] = [];
  private broker: string = '';
  private args: AnimateExArgsType[] = [];
  private isImmediately: boolean = false;
  public name: string = '';
  public state: AnimateExState = AnimateExState.INIT;
  // extend properties for new task
  public destroyCallback: ((task: object) => void) | undefined = undefined;

  constructor(name: string) {
    this.name = name;
  }

  public set duration(duration: number) {
    this.overrideParam.duration = duration;
  }

  public init(param: AnimateParam,
              event: AnimateExCallback,
              onFinish: AnimateExCallback,
              immediately: boolean = false): void {
    this.initOverrideParam(param);
    this.originEvents.push(event);
    this.addOnFinish(onFinish, true);
    this.isImmediately = immediately;
  }

  public initOverrideParam(param: AnimateParam): void {
    if (!param) {
      return;
    }
    let keys = Object.keys(param);
    keys.forEach((key) => {
      if (key !== 'onFinish') {
        this.overrideParam[key] = param[key];
      }
    })
  }

  private doOverrideEvent(): void {
    // do event fallthrough, support args
    let len = this.originEvents.length;
    for (let i = 0; i < len; i++) {
      this.originEvents[i](...this.args);
    }
  }

  private doOverrideOnFinish(): void {
    hilog.info(DOMAIN, this.TAG, `animation ${this.name} OnFinish, current state: ${this.state}`);
    // do unbreakable onFinish fallthrough, support args
    let len = this.unBreakableOnFinish.length;
    for (let i = 0; i < len; i++) {
      this.unBreakableOnFinish[i](...this.args);
    }

    // if not break, do breakableOnFinish fall through
    if (this.state === AnimateExState.BROKEN) {
      hilog.warn(DOMAIN, this.TAG,
        `animation ${this.name} is broken by ${this.broker}, do not do breakable OnFinish callbacks.`);
    } else {
      // do breakable onFinish fallthrough, support args
      let len = this.breakableOnFinish.length;
      for (let i = 0; i < len; i++) {
        this.breakableOnFinish[i](...this.args);
      }
    }
    this.destroyCallback?.(this);
    this.state = AnimateExState.DONE;
  };

  public addEvent(event: AnimateExCallback): boolean {
    if (this.originEvents.includes(event)) {
      hilog.warn(DOMAIN, this.TAG, `animation ${this.name} has event [${event}] already, do not add event again.`);
      return false;
    }
    this.originEvents.push(event);
    return true;
  }

  public addOnFinish(onFinish: AnimateExCallback, breakable: boolean = true): boolean {
    // breakable onFinish
    if (breakable) {
      if (this.breakableOnFinish.includes(onFinish)) {
        hilog.warn(DOMAIN, this.TAG,
          `animation ${this.name} has breakable onFinish [${onFinish}] already, do not add breakable onFinish again.`);
        return false;
      }
      this.breakableOnFinish.push(onFinish);
      return true;
    }

    if (this.unBreakableOnFinish.includes(onFinish)) {
      hilog.warn(DOMAIN, this.TAG,
        `animation ${this.name} has not breakable onFinish [${onFinish}] already, do not add onFinish again.`);
      return false;
    }
    this.unBreakableOnFinish.push(onFinish);
    return true;
  }

  public start(...args: AnimateExArgsType[]): boolean {
    this.args = args;
    this.state = AnimateExState.ANIMATING;
    this.onStart();
    hilog.info(DOMAIN, this.TAG, `animation ${this.name} starts, current state: ${this.state}`);
    return true;
  }

  private onStart(): void {
    let task = this;
    task.overrideParam.onFinish = () => {
      task.doOverrideOnFinish();
    }
    if (!this.isImmediately) {
      animateTo(task.overrideParam, () => {
        task.doOverrideEvent();
      });
      return;
    }
    animateToImmediately(task.overrideParam, () => {
      task.doOverrideEvent();
    });
  }

  public break(broker: string): boolean {
    if (this.state === AnimateExState.ANIMATING) {
      this.broker = broker;
      this.state = AnimateExState.BROKEN;
      hilog.info(DOMAIN, this.TAG, `animation ${this.name} is broken by ${broker}, current state: ${this.state}`);
    }
    return true;
  }

  public produce(): AnimateExTask {
    let task = new AnimateExTask(this.name);
    // shallow copy
    task.overrideParam = this.overrideParam;
    task.originEvents = this.originEvents;
    task.unBreakableOnFinish = this.unBreakableOnFinish;
    task.breakableOnFinish = this.breakableOnFinish;
    task.state = this.state;
    task.isImmediately = this.isImmediately;
    return task;
  }
}

class AnimateExTask extends AnimateExSkeleton {
  private static gTaskID = 0;
  public id: number = AnimateExTask.gTaskID;

  constructor(skeletonName: string) {
    super(skeletonName);
    this.id = AnimateExTask.gTaskID;
    AnimateExTask.gTaskID++;
  }
}

export class AnimateExManager {
  private name: string = 'defaultAnimateExManager';
  private animateSkeletons: Map<string, AnimateExSkeleton> = new Map<string, AnimateExSkeleton>();
  private animateTasks: AnimateExTask[] = [];
  private animateExTaskManagerDestroyCallback = (task: object) => {
    let tmp = task as AnimateExTask;
    let index = this.animateTasks.findIndex((item) => {
      return ((item.id === tmp.id) && (item.name === tmp.name))
    });
    if (index !== -1) {
      this.animateTasks.splice(index, 1);
    }
  }

  constructor(name?: string) {
    if (name) {
      this.name = name;
    }
  }

  public new(skeletonName: string,
             param: AnimateParam,
             event: AnimateExCallback,
             onFinish: AnimateExCallback,
             immediately: boolean = false): AnimateExManager {
    if (this.animateSkeletons.has(skeletonName)) {
      hilog.warn(DOMAIN, this.name, '${public}s is exist already, do not create new animation again.', skeletonName);
      return this;
    }
    let skeleton = new AnimateExSkeleton(skeletonName);
    skeleton?.init(param, event, onFinish, immediately);
    this.animateSkeletons.set(skeletonName, skeleton);
    return this;
  }

  public get(skeletonName: string): AnimateExSkeleton | undefined {
    return this.animateSkeletons.get(skeletonName);
  }

  public delete(skeletonName: string): boolean {
    return this.animateSkeletons.delete(skeletonName);
  }

  public addEvent(skeletonName: string, event: AnimateExCallback): boolean {
    let skeleton = this.animateSkeletons.get(skeletonName);
    if (!skeleton) {
      return false;
    }
    skeleton.addEvent(event);
    return true;
  }

  public addOnFinish(skeletonName: string, onFinish: AnimateExCallback, breakable: boolean = true): boolean {
    let skeleton = this.animateSkeletons.get(skeletonName);
    if (!skeleton) {
      return false;
    }
    skeleton.addOnFinish(onFinish, breakable);
    return true;
  }

  public start(skeletonName: string, ...args: AnimateExArgsType[]): boolean {
    let skeleton = this.animateSkeletons.get(skeletonName);
    if (!skeleton) {
      return false;
    }
    // produce a new instance from AnimateExSkeleton
    let task = skeleton.produce();
    hilog.info(DOMAIN, this.name, `produce new task from skeleton ${task.name}, ${task.id}, ${task.state}}`);
    task.destroyCallback = this.animateExTaskManagerDestroyCallback;
    this.animateTasks.push(task);
    return task.start(...args);
  }

  public start2(skeletonName: string, param: AnimateParam, ...args: AnimateExArgsType[]): boolean {
    let skeleton = this.animateSkeletons.get(skeletonName);
    if (!skeleton) {
      return false;
    }
    // produce a new instance from AnimateExSkeleton
    let task = skeleton.produce();
    hilog.info(DOMAIN, this.name, `produce new task with param from skeleton ${task.name}, ${task.id}, ${task.state}}`);
    task.destroyCallback = this.animateExTaskManagerDestroyCallback;
    task.initOverrideParam(param);
    this.animateTasks.push(task);
    return task.start(...args);
  }

  // create an oneshot animate task, duration is 0. same as animateTo({duration: 0})
  public oneShot(skeletonName: string, ...args: AnimateExArgsType[]): boolean {
    let skeleton = this.animateSkeletons.get(skeletonName);
    if (!skeleton) {
      return false;
    }
    let task = skeleton.produce();
    task.duration = 0;
    hilog.info(DOMAIN, this.name, `produce a oneshot task from skeleton ${task.name}, ${task.id}, ${task.state}}`);
    return task.start(...args);
  }

  public break(skeletonName: string, broker: string): boolean {
    this.animateTasks.forEach((item) => {
      if (item.name === skeletonName) {
        item.break(broker);
      }
    });
    return true;
  }
}

const defaultAnimateExManagerInstance = SingletonHelper.getInstance(AnimateExManager, 'AnimateExManager');

/**
 * extend animateTo function, create new animation object and start animation immediately.
 * animateEx new features:
 * 1. object-oriented design, every animation is an object, create new animation object by animateExNew();
 * 2. support unique name, get animation object animateExGet(name);
 * 3. support state(INIT/ANIMATING/DONE), get state by animateExGet(name).state;
 * 4. support break when animation is playing, when break, overrideOnFinish callback will do not execute,
 * break animation by animateExBreak(name)
 * 5. support execute multi events in one animateTo, add multi events to animation by animateExAddEvent();
 *
 * @param name  { string } - animation name.
 * @param param { AnimateParam } - Set animation effect parameters.
 * @param event { function } - Specify the closure function that displays dynamic effects,
 * and the system will automatically insert transition animations for state changes caused by the closure function.
 * @param onFinish { function } - onFinish callback after animation.
 * @param args  { AnimateExArgsType[] } - args for event and onFinish.
 * @param immediately { boolean } - set animate callback is animateTo or animateToImmediately, default is animateTo.
 * @returns void
 *
 */
export function animateExTo(name: string,
                            param: AnimateParam,
                            event: AnimateExCallback,
                            onFinish: AnimateExCallback,
                            ...args: AnimateExArgsType[]): void {
  defaultAnimateExManagerInstance.new(name, param, event, onFinish);
  defaultAnimateExManagerInstance.start(name, ...args);
}

/*
* extend animateToImmediately function, create new animation object and start animation immediately.
* @param name  { string } - animation name.
  * @param param { AnimateParam } - Set animation effect parameters.
  * @param event { function } - Specify the closure function that displays dynamic effects,
  * and the system will automatically insert transition animations for state changes caused by the closure function.
  * @param onFinish { function } - onFinish callback after animation.
  * @param args  { AnimateExArgsType[] } - args for event and onFinish.
  * @param immediately { boolean } - set animate callback is animateTo or animateToImmediately, default is animateTo.
  * @returns void
  *
  */
export function animateExToImmediately(name: string,
                                       param: AnimateParam,
                                       event: AnimateExCallback,
                                       onFinish: AnimateExCallback,
                                       ...args: AnimateExArgsType[]): void {
  defaultAnimateExManagerInstance.new(name, param, event, onFinish, true);
  defaultAnimateExManagerInstance.start(name, ...args);
}

/**
 * get animation object by name
 *
 * @param name  { string } - animation name.
 * @returns { AnimateExSkeleton | undefined } - return animation object, return undefined if animation is not existed
 */
export function animateExGet(name: string): AnimateExSkeleton | undefined {
  return defaultAnimateExManagerInstance.get(name);
}

/**
 * only create new animation object, do not start it
 *
 * @param name  { string } - animation name.
 * @param param { AnimateParam } - Set animation effect parameters.
 * @param event { function } - Specify the closure function that displays dynamic effects,
 * and the system will automatically insert transition animations for state changes caused by the closure function.
 * @param onFinish { function } - onFinish callback after animation.
 * @param immediately { boolean } - default is false, false: animation callback is animateTo,
 * true: animation callback is animateToImmediately.
 *
 */
export function animateExNew(name: string,
                             param: AnimateParam,
                             event: AnimateExCallback,
                             onFinish: AnimateExCallback,
                             immediately: boolean = false): AnimateExManager {
  return defaultAnimateExManagerInstance.new(name, param, event, onFinish, immediately);
}

/**
 * delete animation by name
 *
 * @param name  { string } - animation name.
 * @returns { boolean } - true: delete success, false: delete failed. for examples: animation is not existed
 */
export function animateExDelete(name: string): boolean {
  return defaultAnimateExManagerInstance.delete(name)
}

/**
 * add new event function to animation object, all event functions execute in one animateTo
 *
 * @param name  { string } - animation name.
 * @param event { function } - Specify the closure function that displays dynamic effects,
 * and the system will automatically insert transition animations for state changes caused by the closure function.
 * @returns { boolean } - true: add event to animation success, false: add event to animation failed,
 * for examples: animation is not existed
 */
export function animateExAddEvent(name: string, event: AnimateExCallback): boolean {
  return defaultAnimateExManagerInstance.addEvent(name, event);
}

/**
 * add new onFinish function to animation object, onFinish support breakable
 *
 * @param name  { string } - animation name.
 * @param onFinish { function } - Specify the closure function invoked when the animation playback is complete.
 * @param breakable { boolean } - true: when animation broken by break(), this onFinish will not execute;
 * false: onFinish invoked anyway when animation is finished
 * @returns { boolean } - true: add onFinish to animation success, false: add onFinish to animation failed,
 * for examples: animation is not existed
 */
export function animateExAddOnFinish(name: string, onFinish: AnimateExCallback, breakable: boolean = true): boolean {
  return defaultAnimateExManagerInstance.addOnFinish(name, onFinish, breakable);
}

/**
 * start animation by name
 *
 * @param name  { string } - animation name.
 * @param args  { AnimateExArgsType[] } - args for event and onFinish.
 * @returns { boolean } - true: start animation success, false: start animation failed,
 * for examples: animation is not existed
 */
export function animateExStart(name: string, ...args: AnimateExArgsType[]): boolean {
  return defaultAnimateExManagerInstance.start(name, ...args);
}

/**
 * start an oneshot animation by name, same as animateTo({duration: 0})
 *
 * @param name  { string } - animation name.
 * @param args  { AnimateExArgsType[] } - args for event and onFinish.
 * @returns { boolean } - true: start animation success, false: start animation failed,
 * for examples: animation is not existed
 */
export function animateExOneShot(name: string, ...args: AnimateExArgsType[]): boolean {
  return defaultAnimateExManagerInstance.oneShot(name, ...args);
}

/**
 * break animation by name, when animation is broken,  breakable onFinish will not execute
 *
 * @param name  { string } - animation name.
 * @param broker { string } - who break this animation, for dfx
 * @returns { boolean } - true: break animation success, false: break animation failed,
 * for examples: animation is not existed
 */
export function animateExBreak(name: string, broker: string): boolean {
  return defaultAnimateExManagerInstance.break(name, broker);
}