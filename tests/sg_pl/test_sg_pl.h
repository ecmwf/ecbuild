#ifndef TEST_SG_PL_H
#define TEST_SG_PL_H

// Case 1: Regular (non-template) class with base and member
class RegularClass : public BaseClass {
public:
    int value;
};

// Case 2: Template class with base and member
template <class T>
class TemplateClass : public BaseClass {
public:
    T data;
};

// Case 3: Explicit template specialization -- must not crash sg.pl
template <>
class TemplateClass<int> : public BaseClass {
public:
    int data;
};

// Case 4: Explicit specialization with no body (semicolon-only form)
template <>
class TemplateClass<double>;

// Case 5: Class after the specializations -- tests parser recovery
class AfterSpecClass : public BaseClass {
public:
    double result;
};

#endif
