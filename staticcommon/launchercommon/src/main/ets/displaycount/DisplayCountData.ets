/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

import { StyleConstants } from '../constants/StyleConstants';

/**
 * swiper的displayCount nextMargin属性管理类
 */
@Observed
export class DisplayCountData {
  /**
   * swiper的displayCount属性
   * 本变量是个状态变量
   */
  @Track private displayCount: number = StyleConstants.DEFAULT_1;

  /**
   * Grid nextMargin属性
   */
  @Track private nextMargin: number = StyleConstants.DEFAULT_0;

  /**
   * Grid preMargin属性
   */
  @Track private preMargin: number = StyleConstants.DEFAULT_0;

  /**
   * Grid preMargin属性
   */
  @Track private cacheCount: number = 0;

  /**
   * 设置displayCount
   * @param displayCount
   */
  public setDisplayCount(displayCount: number): void {
    this.displayCount = displayCount;
  }

  /**
   * 获取displayCount
   * @returns
   */
  public getDisplayCount(): number {
    return this.displayCount;
  }


  /**
   * 设置cacheCount
   * @param cacheCount
   */
  public setCacheCount(cacheCount: number): void {
    this.cacheCount = cacheCount;
  }

  /**
   * 获取cacheCount
   * @returns
   */
  public getCacheCount(): number {
    return this.cacheCount;
  }

  /**
   * 获取nextMargin
   * @returns nextMargin
   */
  public getNextMargin(): number {
    return this.nextMargin;
  }

  /**
   * 设置nextMargin
   * @param nextMargin
   */
  public setNextMargin(nextMargin: number): void {
    this.nextMargin = nextMargin;
  }

  /**
   * 获取preMargin
   * @returns preMargin
   */
  public getPreMargin(): number {
    return this.preMargin;
  }

  /**
   * 设置preMargin
   * @param preMargin
   */
  public setPreMargin(preMargin: number): void {
    this.preMargin = preMargin;
  }

  /**
   * 输出日志
   * @returns 类信息
   */
  public log(): string {
    return `preMargin:${this.preMargin} nextMargin:${this.nextMargin} cacheCount:${this.cacheCount} displayCount:${this.displayCount}`;
  }
}